# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

function prompt()
{
    git status > /dev/null 2>&1
    if [ $? -eq 0 ] ; then
	BRANCH=`git rev-parse --abbrev-ref HEAD`
	BRANCH_BASENAME=`basename $BRANCH`
	echo -e '\033]2;'${BRANCH}'\007'
    else
	printf "\033]0;%s@%s:%s\007" "${USER}" "${HOSTNAME%%.*}" "${PWD/#$HOME/~}"
    fi
}

function tempo_log()
{
    LOG=~/.tempo.log
    JIRA="NONE"
    git status > /dev/null 2>&1
    if [ $? -eq 0 ] ; then
        JIRA=`/bin/git rev-parse --abbrev-ref HEAD | cut -d\/ -f2 | cut -d\- -f1-2`
    fi
    TIMESTAMP=`date '+%Y%m%d %H:%M:%S'`
    HOSTNAME=`hostname -s`
    echo "${TIMESTAMP}|${HOSTNAME}|${JIRA}|${1}" >> $LOG
}

function make()
{
    tempo_log "make"
    /bin/make "$@"
}

function setsdk()
{
    VERSION=$1
    SELECTED_COUNT=`ls -ald $TBRICKS/*sdk-*$VERSION | wc -l`
    if [ -z "$SELECTED_COUNT" ]; then
        echo "No sdk version: $VERSION"
        return
    elif [ $SELECTED_COUNT != "1" ]; then
        echo "$VERSION is ambiguous when selecting sdk"
        return
    else
        export SDK=`eval echo "$TBRICKS/*sdk-*$VERSION"`
        rm -f $TBRICKS/sdk
        ln -s $SDK $TBRICKS/sdk
        rm -rf $TB_APPS/.ccls-cache
#        find $TB_APPS -name compile_commands.json -exec rm '{}' \;
        recompute_manpath
        echo "SDK is $SDK"
    fi
}

function recompute_manpath()
{
    MANPATH=/usr/share/man:/usr/local/share/man:/usr/share/locale/man:
    MANPATH+=$LLVM/share/man:$GCC_SUITE/share/man:
    MANPATH+=$ADMIN_ROOT/doc/man:$SDK/doc/man:$SDK/doc/libraries/strategy/man
    export MANPATH
}

export PROMPT_COMMAND=prompt
export PS1='\[\e[1;32m\]\h:\W\[\e[m\]$ '

export TBRICKS="$HOME/tbricks"
export TBRICKS_ADMIN_CENTER=john.mcmullan_system
export TBRICKS_ROOT=$TBRICKS
export ADMIN_ROOT="$TBRICKS/admin"
export SDK=$TBRICKS/sdk

# clang++
LLVM="/opt/llvm-6.0"
# g++
GCC_SUITE="/opt/gcc-8.2.0"
export GCC_SUITE LLVM

recompute_manpath

if [ -f ${ADMIN_ROOT}/etc/bash/.tbricks_completion.bash ] ; then
    source $ADMIN_ROOT/etc/bash/.tbricks_completion.bash
fi

if [ -f ~/.git-completion.bash ] ; then
    source ~/.git-completion.bash
fi

export TB_APPS=$HOME/work/apps
export MAKE=gmake

#export HTTP_PROXY=http://proxy.orcsoftware.com:3128
#export HTTPS_PROXY=http://proxy.orcsoftware.com:3128
#export http_proxy=$HTTP_PROXY
#export https_proxy=$HTTPS_PROXY
export CA_CERT_FILE=/etc/pki/tls/certs/ca-bundle.crt

alias em='emacsclient --no-wait'
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
