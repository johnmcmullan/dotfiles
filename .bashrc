# .bashrc

# Source global definitions
if [ -f /etc/bashrc ] ; then
    . /etc/bashrc
fi

if [ -f .tbricksrc ] ; then
    . .tbricksrc
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

alias em='emacsclient -nw'
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
