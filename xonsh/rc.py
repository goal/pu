#!/usr/bin/env python

from xontrib import vox
from xontrib import zoxide

from xonsh.built_ins import XSH

env = XSH.env
# adjust some paths
env["PATH"].append("/home/wyj/bin")
env["PATH"].append("/home/wyj/.local/bin")

env["LD_LIBRARY_PATH"] = ["/home/wyj/.local/lib"]
env["GOPROXY"] = "https://mirrors.aliyun.com/goproxy/"

# some customization options, see https://xon.sh/envvars.html for details
env["MULTILINE_PROMPT"] = "`·.,¸,.·*¯`·.,¸,.·*¯"
env["XONSH_SHOW_TRACEBACK"] = True
env["XONSH_STORE_STDOUT"] = True
env["XONSH_HISTORY_MATCH_ANYWHERE"] = True
env["COMPLETIONS_CONFIRM"] = True
env["XONSH_AUTOPAIR"] = True

# prompt
def last_errcode():
    if XSH.history.rtns:
        return_code = XSH.history.rtns[-1]
        if return_code != 0:
            return f"{return_code}"

env["PROMPT_FIELDS"]["last_errcode"] = last_errcode
env["PROMPT"] = "{BLUE}{hostname} {GREEN}{short_cwd}{RESET}{gitstatus: ({})}{RESET} "
env["RIGHT_PROMPT"] = "{current_job} {#604461}{localtime}{RESET}{last_errcode: {{RED}}{}{{RESET}}}"

# git
XSH.aliases["gd"] = ["git", "diff"]
XSH.aliases["gcm"] = ["git", "commit"]
XSH.aliases["gst"] = ["git", "status"]
XSH.aliases["gco"] = ["git", "checkout"]

# ls
XSH.aliases["ll"] = ["ls", "-l"]

# neovim
XSH.aliases["vv"] = ["nvim"]

# tmux
XSH.aliases["tat"] = ["tmux", "attach", "-t"]
XSH.aliases["tns"] = ["tmux", "new-session", "-s"]

