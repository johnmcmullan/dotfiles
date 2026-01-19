# .bashrc

# Source global definitions
[ -f /etc/bashrc ] && source /etc/bashrc

# Tbricks specific functions and setup
[ -f .tbricksrc ] && source .tbricksrc

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

[ -f ~/.git-completion.bash ] && source ~/.git-completion.bash

# old proxy settings
#export HTTP_PROXY=http://proxy.orcsoftware.com:3128
#export HTTPS_PROXY=http://proxy.orcsoftware.com:3128
#export http_proxy=$HTTP_PROXY
#export https_proxy=$HTTPS_PROXY
#export CA_CERT_FILE=/etc/pki/ca-bundle.crt

# MS proxy settings
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

# Smarter shell behavior
shopt -s cdspell        # Autocorrect typos in cd
shopt -s autocd         # Just type directory name to cd
shopt -s dirspell       # Autocorrect directory names in completion
shopt -s nocaseglob     # Case-insensitive globbing

# Better completion
[ -f /etc/bash_completion ] && source /etc/bash_completion
bind 'set completion-ignore-case on' 2>/dev/null
bind 'set show-all-if-ambiguous on' 2>/dev/null

alias em='emacsclient -nw'
# https://www.atlassian.com/git/tutorials/dotfiles
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'

# Calculator with math library
alias bc='bc -l'

# Better ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Navigation aliases
alias ..='cd ..'
alias ...='cd ../..'

# Colored grep
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# ripgrep with smart case
alias rg='rg --smart-case'

umask 007

# Set default PATH only if not at work (tbricksrc sets PATH)
if [ -z "$TB_APPS" ] ; then
    PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin:$HOME/bin:$HOME/.local/bin
    export PATH
fi

# Universal archive extractor
extract() {
    if [ -f "$1" ]; then
        case "$1" in
            *.tar.bz2)   tar xjf "$1"    ;;
            *.tar.gz)    tar xzf "$1"    ;;
            *.bz2)       bunzip2 "$1"    ;;
            *.gz)        gunzip "$1"     ;;
            *.tar)       tar xf "$1"     ;;
            *.zip)       unzip "$1"      ;;
            *.Z)         uncompress "$1" ;;
            *)           echo "'$1' cannot be extracted" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

recompute_bin() {
    local bin_dir="$HOME/bin"
    local copilot_dir="$HOME/copilot_projects"
    
    mkdir -p "$bin_dir"
    
    find -L "$copilot_dir" -type f -executable 2>/dev/null | while read -r file; do
        local name=$(basename "$file")
        local link="$bin_dir/$name"
        
        # Skip if already correctly linked
        [[ -L "$link" ]] && [[ "$(readlink "$link")" == "$file" ]] && continue
        
        # Skip if real file exists (not a symlink)
        [[ -e "$link" ]] && [[ ! -L "$link" ]] && continue
        
        # Create/update symlink
        ln -sf "$file" "$link"
    done
}

# bun
BUN_INSTALL="$HOME/.bun"
if [ -d "$BUN_INSTALL" ] ; then
	export BUN_INSTALL
	export PATH="$BUN_INSTALL/bin:$PATH"
fi

# fzf integration (fuzzy finder for history/files)
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# local access tokens
[ -f .access_tokens ] && source .access_tokens

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

