# coding: utf-8

import argparse
import os
import yaml
from pathlib import Path
import logging
import shutil
from os.path import join as path_join

from utils import common_suffix, get_machine_tag, get_env_config, get_available_packages

# TODO: add package dependencies ?

logging.basicConfig(level=logging.DEBUG, format="[%(levelname)8s] : %(message)s")
log = logging.getLogger("install")

PKG_MANIFEST = "MANIFEST"


def install_from_pkg(ctx, what, pkg_root, backup=True, dest=None, dry_run=False):
    """
    Install a package file to dest

    :param what: full path to what to install, from inside the package
    :param ctx: the env context
    :param pkg_root: full path to the root of the package
    :param backup:
    :param dest: destination directory
    :param dry_run:
    :return:
    """

    if dest is None:
        dest = ctx["home"]

    # get the relative path of the file inside the package
    # so that it can be created in the destination directory
    rel_path = os.path.relpath(what, pkg_root)

    dst_dir = path_join(dest, os.path.dirname(rel_path))
    dst_file = path_join(dst_dir, os.path.basename(what))

    log.debug("create target directory: {}".format(dst_dir))
    if not dry_run:
        try:
            # TODO: preseve permissions
            os.makedirs(dst_dir, exist_ok=True)
        except Exception as e:
            log.error("error making dirs {}: {}".format(dst_dir, e))
            return

    if os.path.isfile(dst_file) or os.path.islink(dst_file):
        # TODO: backup
        log.info("cleaning file {}".format(dst_file))
        if not dry_run:
            os.unlink(dst_file)
    elif os.path.isdir(dst_file):
        # TODO: backup
        log.info("cleaning dir {}".format(dst_file))
        if not dry_run:
            shutil.rmtree(dst_file)

    log.info("symlink-ing {} to {}".format(what, dst_file))
    if not dry_run:
        os.symlink(what, dst_file)


def install_package(name, ctx, backup=True, dest=None, dry_run=False):
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
        raise ValueError("package '{}' not found".format(name))

    try:
        with open(path_join(pkg_path, PKG_MANIFEST)) as f:
            manifest = yaml.load(f)
    except OSError as e:
        log.warning("no {} for package {}".format(PKG_MANIFEST, name))
        # create a default: install all files from the package
        manifest = {"*": {}}

    for glob, data in manifest.items():
        p = Path(pkg_path)

        for item in p.glob(glob):
            if os.path.basename(item) == PKG_MANIFEST:
                continue

            log.info("pkg {}: installing {}".format(name, item))

            if os.path.islink(item):
                log.error("not handling symlink {} in package {}".format(item, name))
                continue

            elif os.path.isfile(item) or os.path.isdir(item):
                install_from_pkg(ctx, item, pkg_path, backup=backup, dest=dest, dry_run=dry_run)


def install_profile(profile, config, dry_run=False):
    """
    Install a profile.

    Configuration file looks like:

    packages:
    - zsh
    - tmux
    - ...

    """
    profile_path = path_join(config["source"], "profiles", profile)
    if not os.path.isfile(profile_path):
        log.error("can't find profile {} (looked in: {})".format(profile, profile_path))

    with open(profile_path) as f:
        data = yaml.safe_load(f)

    if "packages" not in data:
        log.error("invalid profile configuration")
        return

    for package in data.get("packages", []):
        install_package(package, config, dry_run=dry_run)


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
