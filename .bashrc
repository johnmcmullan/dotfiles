# .bashrc

# Source global definitions
if [ -f /etc/bashrc ] ; then
    . /etc/bashrc
fi

# Tbricks specific functions and setup
if [ -f .tbricksrc ] ; then
    . .tbricksrc
fi

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

if [ -f ~/.git-completion.bash ] ; then
    source ~/.git-completion.bash
fi

if [ -x ~/.iterm2_shell_integration.bash ] ; then
	source ~/.iterm2_shell_integration.bash
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

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
