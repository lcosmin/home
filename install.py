# coding: utf-8

import argparse
import os
import yaml
from pathlib import Path
import logging
import shutil
from os.path import join as path_join

from utils import common_suffix, get_machine_tag, get_env_config, get_available_packages, really_exists

# TODO: add package dependencies ?
# TODO: make dest work

logging.basicConfig(level=logging.DEBUG, format="[%(levelname)8s] : %(message)s")
log = logging.getLogger("install")

PKG_MANIFEST = "MANIFEST"


def install_from_pkg(pkg_name, ctx, what, pkg_root, dest, backup=True, dry_run=False):
    """
    Install a package file to dest

    :param pkg_name: name of the package which we're installing from
    :param ctx: the env context
    :param what: full path to what to install, from inside the package

    :param pkg_root: full path to the root of the package
    :param backup:
    :param dest: destination directory
    :param dry_run:
    :return:
    """

    rel_path = os.path.relpath(what, pkg_root)
    dir_name = os.path.dirname(rel_path)

    # don't join the path if dir_name is empty, because it appends a trailing / to the path (e.g. /asd vs /asd/),
    # which messes up with the check for cleaning up (e.g. if /asd is a symlink to a directory, /asd would be cleaned
    # up, but /asd/ won't)
    dst_dir = path_join(dest, dir_name) if dir_name else dest

    dst_file = path_join(dst_dir, os.path.basename(what))

    #
    # Clean up any file that might be in the way, then create the target directory.
    #
    if really_exists(dst_dir) and not os.path.isdir(dst_dir):
        log.warning("package {}: destination '{}' exists, but it's not a dir, removing".format(pkg_name, dst_dir))
        if not dry_run:
            os.unlink(dst_dir)

    log.debug("package {}: md {}".format(pkg_name, dst_dir))
    if not dry_run:
        try:
            # TODO: preseve permissions
            os.makedirs(dst_dir, exist_ok=True)
        except Exception as e:
            log.error("package {}: error making dirs {}: {}".format(pkg_name, dst_dir, e))
            return

    if os.path.isfile(dst_file) or os.path.islink(dst_file):
        # TODO: backup
        log.debug("package {}: rm {}".format(pkg_name, dst_file))
        if not dry_run:
            os.unlink(dst_file)
    elif os.path.isdir(dst_file):
        # TODO: backup
        log.info("package {}: rm -rf {}".format(pkg_name, dst_file))
        if not dry_run:
            shutil.rmtree(dst_file)

    log.info("package {}: ln -s {} --> {}".format(pkg_name, what, dst_file))
    if not dry_run:
        os.symlink(what, dst_file)


def install_package(name, ctx, dest=None, backup=True, dry_run=False):
    """

    :param name: name of the package to install ( like .dotfiles/packages/<this-name> )
    :param ctx: env_context
    :param backup: bool, if to backup or not
    :param dest:
    :param dry_run:
    :return:
    """

    pkg_path = path_join(ctx["source"], "packages/{}".format(name))
    if not os.path.isdir(pkg_path):
        log.error("package {} not found".format(name))
        return

    try:
        manifest_path = path_join(pkg_path, PKG_MANIFEST)
        with open(manifest_path) as f:
            manifest = yaml.load(f)
            log.debug("package {}: loaded manifest file".format(manifest_path))
    except OSError as e:
        log.warning("no {} for package {}".format(PKG_MANIFEST, name))
        # create a default: install all files from the package
        dest = os.path.expanduser(dest) if dest else ctx["home"]
        manifest = {"install": [{"pattern": "*", "dest": dest}]}

    for data in manifest.get("install", []):

        glob = data.get("pattern", "*")
        p = Path(pkg_path)

        # destination path
        dest_path = dest if dest is not None else os.path.expanduser(data.get("dest", ctx["home"]))

        log.debug("package {}: installing glob pattern '{}' into {}".format(name, glob, dest_path))

        for item in p.glob(glob):
            log.debug("package {}: processing globbed item: {}".format(name, item))
            if os.path.basename(item) == PKG_MANIFEST:
                continue

            if os.path.islink(item):
                log.error("not handling symlink {} in package {}".format(item, name))
                continue

            elif os.path.isfile(item) or os.path.isdir(item):
                install_from_pkg(name, ctx, item, pkg_path, dest_path, backup=backup, dry_run=dry_run)

            else:
                raise Exception("unhandled case")


def install_profile(profile, ctx, dest=None, dry_run=False):
    """
    Install a profile.

    Configuration file looks like:

    packages:
    - zsh
    - tmux
    - ...
    """

    profile_path = path_join(ctx["source"], "profiles", profile)
    if not os.path.isfile(profile_path):
        log.error("can't find profile {} (looked in: {})".format(profile, profile_path))

    with open(profile_path) as f:
        data = yaml.safe_load(f)

    if "packages" not in data:
        log.error("invalid profile configuration")
        return

    for package in data.get("packages", []):
        install_package(package, ctx, dest, dry_run=dry_run)


def main():
    p = argparse.ArgumentParser()

    config = get_env_config()

    p.add_argument("-n", "--dry-run", help="only display the operations that will be executed", action="store_true")
    p.add_argument("-p", "--packages", help="specify packages to install (comma delimited)")
    p.add_argument("-P", "--profile", help="install specified profile (machine tag: {})".format(config["machine_tag"]))
    p.add_argument("-l", "--list", help="list available packages", action="store_true")
    p.add_argument("-d", "--dump-config", help="show configuration", action="store_true")

    args = p.parse_args()

    if args.list:
        log.info("Available packages:")
        for p in get_available_packages(config["source"]):
            log.info("- {}".format(p))
        return

    if args.dump_config:
        log.info(config)

    if args.profile:
        install_profile(args.profile, config, dry_run=args.dry_run)

    if args.packages:
        for p in args.packages.split(","):
            install_package(p, config, dry_run=args.dry_run)


if __name__ == "__main__":
    main()
