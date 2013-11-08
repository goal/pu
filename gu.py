#!/usr/bin/env python
#encoding=utf-8

import os
import sys
import json
import subprocess


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

for git_repo in sort_repo(repo_dict["git"]):
    repo_name = os.path.split(git_repo)[1]
    if repo_name in target_sdirs:
        os.chdir(repo_name)
        print(repo_name)
        git_up()
        os.chdir("..")
    else:
        git_clone(git_repo)
    print("----------------\n")

for hg_repo in sort_repo(repo_dict["hg"]):
    repo_name = os.path.split(hg_repo)[1]
    if repo_name in target_sdirs:
        os.chdir(repo_name)
        print(repo_name)
        hg_up()
        os.chdir("..")
    else:
        hg_clone(git_repo)
    print("----------------\n")
