#!/bin/bash
# Author: Matej Kastak
# Start date: 2.4.2017
# Modification of bash config from:
# https://natelandau.com/my-mac-osx-bash_profile/
# ---------------------------------------------------------------------------
# Description:  This file holds all my BASH configurations and aliases
#
# Set the shell prompt
# export PS1="\[\e[01;31m\]\u\[\e[0m\]\[\e[00;37m\]@\h:\[\e[0m\]\[\e[00;36m\][\W]\[\e[0m\]\[\e[00;37m\]\\$ \[\e[0m\]"
export PS1="\[\e[32m\]\u\[\e[m\]@\h:\[\e[31m\][\[\e[m\]\W\[\e[31m\]]\[\e[m\]\\$ "

# Set Paths
export PATH="/usr/bin:/bin:/usr/sbin:/sbin:/usr/X11R6/bin:/usr/local/bin"

# Set default Editor
# If emacs is installed use that option otherwise select vim as default editor
if command -v emacsclient >/dev/null 2>&1; then
    export EDITOR="emacsclient -t"
    export VISUAL="emacsclient -t"
else
    export EDITOR=/usr/bin/vim
    export VISUAL=/usr/bin/vim
fi

# Set default pager
export PAGER="less -FSRXc"

# Export prefered web browser
export BROWSER=/usr/bin/firefox

# Set default blocksize for ls, df, du
export BLOCKSIZE=1k

# export CLICOLOR=1
# export LSCOLORS=ExFxBxDxCxegedabagacad

# Set the alias file
ALIAS_FILE=~/.config/bash/aliases

# Set the local bashrc configuration file
LOCAL_BASHRC=~/.bashrc_local

# XDG user specific configuration
export XDG_CONFIG_HOME="$HOME/.config"

# default flags for makepkg
export MAKEFLAGS="-j$(nproc)"
# make: Compile with available threads
alias make='make -j$(nproc)'
# makei: Compile install target with available threads
alias makei='make install -j$(nproc); alert'
# make1: Compiler with all threads except one, let the system keep some resources
alias make1='make -j$(nproc --ignore=1)'

# bind TAB:menu-complete
complete -cf sudo
complete -cf man

# extract:  Extract most know archives with one command
# TODO: improve, there are some missing cases
extract () {
    if [ -f $1 ] ; then
    case $1 in
        *.tar.bz2)   tar xjf $1     ;;
        *.tar.gz)    tar xzf $1     ;;
        *.bz2)       bunzip2 $1     ;;
        *.rar)       unrar e $1     ;;
        *.gz)        gunzip $1      ;;
        *.tar)       tar xf $1      ;;
        *.tbz2)      tar xjf $1     ;;
        *.tgz)       tar xzf $1     ;;
        *.zip)       unzip $1       ;;
        *.Z)         uncompress $1  ;;
        *.7z)        7z x $1        ;;
        *)     echo "'$1' cannot be extracted via extract()" ;;
    esac
    else
    echo "'$1' is not a valid file"
    fi
}

# ii:  display useful host related informaton
ii() {
    echo -e "\nYou are logged on ${RED}$HOST"
    echo -e "\nAdditionnal information:$NC " ; uname -a
    echo -e "\n${RED}Users logged on:$NC " ; w -h
    echo -e "\n${RED}Current date :$NC " ; date
    echo -e "\n${RED}Machine stats :$NC " ; uptime
    echo
}

cd() { builtin cd "$@"; ls; }               # Always list directory contents upon 'cd'
zipf () { zip -r "$1".zip "$1" ; }          # zipf:         To create a ZIP archive of a folder

#   showa: to remind yourself of an alias (given some part of it)
#   ------------------------------------------------------------
showa () { /usr/bin/grep --color=always -i -a1 $@ ~/Library/init/bash/aliases.bash | grep -v '^\s*$' | less -FSRXc ; }

#   add_to_path: Add directory path to local config
#   ------------------------------------------------------------
add_to_path () {
    echo 'export PATH="$PATH:'$(realpath "$1")'" # auto generated' >> $HOME/.local_bashrc
    # If file local configuration exists, load it
    if [ -f $LOCAL_BASHRC ]; then
        source $LOCAL_BASHRC
    fi
}

#   add_to_requirements: Add a word to requirements
#   ------------------------------------------------------------
add_to_requirements () { echo "$1" >> $HOME/.requirements; }

#   add_alias: Add directory path to local config
#   ------------------------------------------------------------
add_alias () { echo "alias $1=$2"; }

#   save_last_command: Add directory path to local config
#   ------------------------------------------------------------
# save_command () { echo "# $*"; } -- This approach does not work for $() commands
save_last_command () { printf "# %s\n" "$(fc -ln -1)" >> $LOCAL_BASHRC; }

# If the alias file existss, source it
if [ -f $ALIAS_FILE ]; then
    source $ALIAS_FILE
fi

# If we are running inside ranger, display it in prompt
if [ -n "$RANGER_LEVEL" ]; then export PS1="[R]$PS1"; fi

# If file local configuration exists, source it
if [ -f $LOCAL_BASHRC ]; then
    source $LOCAL_BASHRC
fi
