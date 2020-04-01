#!/bin/sh

git clone https://github.com/VundleVim/Vundle.vim.git $HOME/.config/vim/bundle/Vundle.vim

vim +PluginInstall +qall || true
nvim +PluginInstall +qall
