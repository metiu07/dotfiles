#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias l='ls -la'
alias c='sudo ~/connect.sh'
alias suspend='systemctl suspend'
PS1='[\u@\h \W]\$ '

stty erase ^?
