#!/bin/sh

git clone https://github.com/VundleVim/Vundle.vim.git $HOME/.config/vim/bundle/Vundle.vim

if ! command -v vim &> /dev/null; then
    vim +PluginInstall +qall
fi

if ! command -v nvim &> /dev/null; then
    nvim +PluginInstall +qall
fi
