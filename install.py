#!/usr/bin/env python3
#encoding=utf8

import os
import sys
from loguru import logger

GIT_REPO_URL = "https://github.com/junegunn/vim-plug"
VIM_PLUG_VIM = os.path.expanduser("~/.local/share/nvim/site/autoload/plug.vim")
CURL_FETCH_CMD = "curl -fLo {} --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim".format(
    VIM_PLUG_VIM)
GIT_CLONE_CMD = "git clone {} ~/R/vim-plug".format(GIT_REPO_URL)
INSTALL_CMD = "install -D {} {}".format("~/R/vim-plug/plug.vim", VIM_PLUG_VIM)


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


def main():
    if os.path.isfile(VIM_PLUG_VIM):
        logger.info("plug.vim already exists.")
        sys.exit(0)
        return

    if try_curl_rawfile():
        logger.error("curl fetch failed.")
        if try_copy_from_git_repo():
            logger.error("git clone & copy file failed.")
            sys.exit(-1)
            return

    logger.info("fetch plug.vim success.")
    sys.exit(0)


if __name__ == "__main__":
    main()
