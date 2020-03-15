#!/usr/bin/env python3
#encoding=utf8

import os
import sys
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
GIT_CLONE_CMD = "git clone {} ~/R/vim-plug".format(VIM_PLUG_GIT_REPO_URL)
TMUX_CONF_PATH = os.path.expanduser("~/.tmux_conf")
INSTALL_CMD = "install -D {} {}".format("~/R/vim-plug/plug.vim", VIM_PLUG_PATH)


def try_curl_rawfile():
    return run_cmd(CURL_FETCH_CMD)


def try_copy_from_git_repo():
    retcode = run_cmd(GIT_CLONE_CMD)
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
    os.link(src, dst)

    logger.info("install tmux config success.")


def main():
    opt = docopt.docopt(__doc__, version=__ver__)
    install_all = opt["all"]
    if opt["vim"] or install_all:
        install_vim_config()
    if opt["tmux"] or install_all:
        install_tmux_config()

    return 0

if __name__ == "__main__":
    main()
