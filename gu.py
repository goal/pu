#!/usr/bin/env python
#encoding=utf-8

import os
import sys
import json
import subprocess

PYTHON3 = False
try:
    import concurrent.futures
    PYTHON3 = True
except:
    pass


GIT_PATH = ["git", "C:/Program Files/Git/bin/git.exe"]
HG_PATH = ["hg", "E:/Program Files/TortoiseHg/hg.exe"]
SVN_PATH = ["svn", "E:/Program Files/TortoiseSvn/svn.exe"]


def get_cmd_bin(cand):
    for i in cand:
        try:
            subprocess.call([i, "--version"])
            return i
        except Exception as e:
            continue

GIT = get_cmd_bin(GIT_PATH)
HG = get_cmd_bin(HG_PATH)
SVN = get_cmd_bin(SVN_PATH)

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
    return subprocess.call([HG, "pull"]) or subprocess.call([HG, "update"])
    
def svn_clone(url):
    """svn clone *"""
    return subprocess.call([SVN, "checkout", url])

def svn_up():
    """svn update"""
    return subprocess.call([SVN, "update"])

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
    ups = {
        GIT: git_up,
        HG: hg_up,
        SVN: svn_up
    }

    clones = {
        GIT: git_clone,
        HG: hg_clone,
        SVN: svn_clone
    }

    up_fun = ups[repo_type]
    clone_fun = clones[repo_type]

    repo_name = os.path.split(target_link)[1]
    if target_link.endswith(".git"):
        repo_name = repo_name[:-4]

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
    excp = future.exception()
    if excp:
        print(excp)
    

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

    repo_types = {
        "git": GIT,
        "hg": HG,
        "svn": SVN
    }
    
    if not PYTHON3:
        for k, v in repo_types.items():
            for repo_name in sort_repo(repo_dict[k]):
                handle_single_target(repo_name, target_dir, v)
        return

    with concurrent.futures.ProcessPoolExecutor(5) as executor:
        for k, v in repo_types.items():
            for repo_name in sort_repo(repo_dict[k]):
                future = executor.submit(handle_single_target, repo_name, target_dir, v)
                future.add_done_callback(done_cb)

if __name__ == '__main__':
    main()
