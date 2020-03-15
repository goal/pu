#!/usr/bin/env python3
#encoding=utf8

import os
import docopt
from loguru import logger

__ver__ = "0.0.1"
__doc__ = """Install user config (vim-plug, tmux config, etc)

Usage:
    install.py all
    install.py vim
    install.py tmux
    install.py emacs
    install.py fish
    install.py -v | --version
    install.py (-h | --help)

Options:
    -v --version  show version
    -h --help     show this screen
"""

VIM_PLUG_GIT_REPO_URL = "https://github.com/junegunn/vim-plug"
VIM_PLUG_PATH = os.path.expanduser("~/.local/share/nvim/site/autoload/plug.vim")
CURL_FETCH_CMD = "curl -fLo {} --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim".format(
    VIM_PLUG_PATH)
TMUX_CONF_PATH = os.path.expanduser("~/.tmux.conf")
INSTALL_CMD = "install -D {} {}".format("~/R/vim-plug/plug.vim", VIM_PLUG_PATH)
FISH_CONFIG_PATH = os.path.expanduser("~/.config/fish")
FISH_CONFIG_REPO_URL = "https://github.com/goal/fish_config"


class Git(object):
    @staticmethod
    def clone(url, target_dir):
        return run_cmd("git clone {} {}".format(url, target_dir))


def try_curl_rawfile():
    return run_cmd(CURL_FETCH_CMD)


def try_copy_from_git_repo():
    retcode = Git.clone(VIM_PLUG_GIT_REPO_URL, "~/R/vim-plug")
    if not retcode:
        retcode = run_cmd(INSTALL_CMD)
    return retcode


def run_cmd(cmd):
    print(cmd)
    retcode = os.system(cmd)
    return retcode


def install_vim_config():
    if os.path.isfile(VIM_PLUG_PATH):
        logger.info("plug.vim already exists.")
        return

    if try_curl_rawfile():
        logger.error("curl fetch failed.")
        if try_copy_from_git_repo():
            logger.error("git clone & copy file failed.")
            return

    logger.info("fetch plug.vim success.")


def install_tmux_config():
    if os.path.isfile(TMUX_CONF_PATH):
        logger.info("{} already exists", TMUX_CONF_PATH)
        return

    src = os.path.abspath("./.tmux.conf")
    dst = TMUX_CONF_PATH
    os.symlink(src, dst)

    logger.info("install tmux config success.")

def install_fish_config():
    if os.path.isdir(FISH_CONFIG_PATH):
        logger.info("{} already exists", FISH_CONFIG_PATH)
        return

    target_dir = os.path.expanduser("~/R/fish_config")
    if not os.path.isdir(target_dir):
        retcode = Git.clone(FISH_CONFIG_REPO_URL, target_dir)
        if not retcode:
            logger.error("git clone fish_config failed.")
            return

    src = target_dir
    dst = FISH_CONFIG_PATH
    os.symlink(src, dst)

    logger.info("install fish config success.")

def main():
    opt = docopt.docopt(__doc__, version=__ver__)
    install_all = opt["all"]
    if opt["vim"] or install_all:
        install_vim_config()
    if opt["tmux"] or install_all:
        install_tmux_config()
    if opt["fish"] or install_all:
        install_fish_config()


    return 0

if __name__ == "__main__":
    main()
