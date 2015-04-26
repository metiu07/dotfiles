#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias l='ls -la'
alias c='sudo ~/connect.sh'
alias suspend='systemctl suspend'
export PS1="\[\e[01;31m\]\u\[\e[0m\]\[\e[00;37m\]@\h:\[\e[0m\]\[\e[00;36m\][\W]\[\e[0m\]\[\e[00;37m\]\\$ \[\e[0m\]""]]]]]]]]"

stty erase ^?
