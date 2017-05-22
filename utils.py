import os
import logging
from os.path import join as path_join
from datetime import datetime


log = logging.getLogger("utils")


def machine_tag():
    try:
        with open(os.path.expanduser("~/.machine-tag")) as f:
            return f.read().strip()
    except:
        return None


def r_path_split(path):
    # split a path, return a list
    res = []
    head = os.path.normpath(path)

    while head and head != "/":
        head, tail = os.path.split(head)
        if tail:
            res.append(tail)
    return res


def common_suffix(path1, path2):

    split_path1 = r_path_split(path1)
    split_path2 = r_path_split(path2)

    print("path1 = {}".format(split_path1))
    print("path2 = {}".format(split_path2))

    return "/".join(reversed(os.path.commonprefix([split_path1, split_path2])))


def env_context():
    """
    Return a dictionary containing variables specific to this installation:
    :return:
    """
    # get script's absolute path
    # get user's home
    # get profiles that can be applied to this machine

    source = os.path.abspath(os.path.dirname(__file__))
    return {
        # directory where this script is run from and where all the configuration files are stored
        "source": source,
        # home directory of the user
        "home": os.path.expanduser("~"),
        # list of directories containing profiles to be applied
        "uname": os.uname()[0].lower(),
        "arch": os.uname()[4].lower(),
        "machine_tag": machine_tag(),
        "backup_dir": path_join(source, "backups/{}".format(datetime.strftime(datetime.now(), "%Y-%m-%d-%H%M%S")))
    }
