#!/bin/sh
#
# This script is used to change color scheme in my urxvt
# Next: Maybe add vimrc files with different colorschemes

if test $1 = molokai
then
    cat colors/temp colors/molokai >> colors/.Xresources
    mv colors/.Xresources ~
    xrdb -merge ~/.Xresources
fi

if test $1 = "solarized-dark"
then
    cat colors/temp colors/solarized-dark >> colors/.Xresources
    mv colors/.Xresources ~
    xrdb -merge ~/.Xresources
fi

if test $1 = "tango"
then
    cat colors/temp colors/tango >> colors/.Xresources
    mv colors/.Xresources ~
    xrdb -merge ~/.Xresources
fi

if test $1 = "base16"
then
    cat colors/temp colors/base16 >> colors/.Xresources
    mv colors/.Xresources ~
    xrdb -merge ~/.Xresources
fi
