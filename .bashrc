# .bashrc

# Source global definitions
if [ -f /etc/bashrc ] ; then
    . /etc/bashrc
fi

# Tbricks specific functions and setup
if [ -f .tbricksrc ] ; then
    . .tbricksrc
    HAVE_TBRICKS=1
fi

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

if [ -f ~/.git-completion.bash ] ; then
    source ~/.git-completion.bash
fi


#export HTTP_PROXY=http://proxy.orcsoftware.com:3128
#export HTTPS_PROXY=http://proxy.orcsoftware.com:3128
#export http_proxy=$HTTP_PROXY
#export https_proxy=$HTTPS_PROXY
#export CA_CERT_FILE=/etc/pki/ca-bundle.crt

#export WWW_HOME=http://www.ms.orcsoftware.com/proxy_index/
#export https_proxy=http://prxlon.ms.orcsoftware.com:3128/
#export http_proxy=http://prxlon.ms.orcsoftware.com:3128/
#export no_proxy=dep01.ms.orcsoftware.com
#export HTTP_PROXY=$http_proxy
#export HTTPS_PROXY=$https_proxy

# ls colors
LS_COLORS='di=1;37'
export LS_COLORS

# set a colored prompt (green user@host, blue directory)
PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '

# timestamps for Bash history
export HISTTIMEFORMAT="%Y-%m-%d %H:%M:%S "
export HISTSIZE=100000
export HISTFILESIZE=${HISTSIZE}
export HISTCONTROL=ignoredups:erasedups
shopt -s histappend

alias em='emacsclient -nw'
# https://www.atlassian.com/git/tutorials/dotfiles
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
alias bc='bc -l'

umask 007

# Set default PATH only if not at work (tbricksrc sets PATH)
if [ -z "$HAVE_TBRICKS" ] ; then
    PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin:$HOME/bin:$HOME/.local/bin
    export PATH
fi

# bun
BUN_INSTALL="$HOME/.bun"
if [ -d "$BUN_INSTALL" ] ; then
	export BUN_INSTALL
	export PATH="$BUN_INSTALL/bin:$PATH"
fi


#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

# opencode
export PATH=/home/john/.opencode/bin:$PATH
