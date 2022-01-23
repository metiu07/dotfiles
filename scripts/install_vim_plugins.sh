#!/bin/sh

if ! command -v vim &> /dev/null; then
    vim +PlugInstall +PlugUpdate +qall
fi

if ! command -v nvim &> /dev/null; then
    vim +PlugInstall +PlugUpdate +qall
fi
