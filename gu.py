#!/usr/bin/env python
#encoding=utf-8

import os
import sys
import json
import subprocess
import concurrent.futures


GIT_PATH = ["git", "C:/Program Files/Git/bin/git.exe"]
HG_PATH = ["hg", "E:/Program Files/TortoiseHg/hg.exe"]


def get_cmd_bin(cand):
    for i in cand:
        try:
            subprocess.call([i, "--version"])
            return i
        except Exception as e:
            continue

GIT = get_cmd_bin(GIT_PATH)
HG = get_cmd_bin(HG_PATH)

FILE_DIR = os.path.dirname(os.path.abspath(__file__))


def git_clone(url):
    """git clone *"""
    return subprocess.call([GIT, "clone", url])


def git_up():
    """git pull"""
    return subprocess.call([GIT, "pull"])


def hg_clone(url):
    """hg clone *"""
    return subprocess.call([HG, "clone", url])

def hg_up():
    """hg pull and update"""
    return subprocess.call([HG, "pull"]) and subprocess.call([HG, "update"])
    
def exists(repo, _dir='.'):
    repo_name = os.path.split(repo)[1]
    sdirs = [i for i in os.listdir(_dir) if os.path.isdir(i)]
    return repo_name in sdirs
    
def sort_repo(repos, _dir='.'):
    clone_repos = []
    up_repos = []
    for i in repos:
        if exists(i, _dir):
            up_repos.append(i)
        else:
            clone_repos.append(i)
    
    print("--------\n clone_repos:")
    for i in clone_repos:
        print(i)

    print("--------\n up_repos:")
    for i in up_repos:
        print(i)

    print("--------\n")

    return clone_repos + up_repos


def handle_single_target(target_link, back_dir, repo_type=GIT):
    # GIT or HG
    up_fun = git_up if repo_type == GIT else hg_up
    clone_fun = git_clone if repo_type == GIT else hg_clone

    repo_name = os.path.split(target_link)[1]
    os.chdir(back_dir)
    target_sdirs = os.listdir(".")
    if repo_name in target_sdirs:
        os.chdir(repo_name)
        print(repo_name)
        up_fun()
        os.chdir("..")
    else:
        clone_fun(target_link)
        print("----------------\n")
    os.chdir(back_dir)


def done_cb(future, *args, **kwargs):
    pass
    

def main():
    if len(sys.argv) < 1:
        print("use: gu.py subdir\n")
        sys.exit(1)

    target = sys.argv[1] or "vp"
    dirs = os.listdir(FILE_DIR)
    if not target in dirs:
        print("wrong arg %s" % target)
        sys.exit(1)

    target_dir = os.path.join(FILE_DIR, target)
    os.chdir(target_dir)
    target_sdirs = os.listdir(".")

    with open("plist.json") as f:
        repo_dict = json.load(f)
    
    with concurrent.futures.ProcessPoolExecutor(5) as executor:
        for repo_name in sort_repo(repo_dict["git"]):
            future = executor.submit(handle_single_target, repo_name, target_dir, GIT)
            future.add_done_callback(done_cb)
        for repo_name in sort_repo(repo_dict["hg"]):
            future = executor.submit(handle_single_target, repo_name, target_dir, HG)
            future.add_done_callback(done_cb)


if __name__ == '__main__':
    main()
