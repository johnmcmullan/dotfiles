# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
    . ~/.bashrc
fi

# User specific environment and startup programs

# PATH
PATH=$HOME/bin:$LLVM/bin:$GCC_SUITE/bin:$ADMIN_ROOT/bin:/opt/maven/bin:/usr/share/centrifydc/bin:/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/opt/tibco/tibrv/8.4/bin:/opt/puppetlabs/bin:$HOME/.local/bin:

export PATH

LD_LIBRARY_PATH=$LLVM/lib64:$GCC_SUITE/lib64:/opt/tibco/tibrv/8.4/lib

export LD_LIBRARY_PATH

tempo_log "login"

test -e "${HOME}/.iterm2_shell_integration.bash" && source "${HOME}/.iterm2_shell_integration.bash" || true

