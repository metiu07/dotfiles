" Vundle setup
set nocompatible
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#rc()

" Plugins to be installed with :PluginsInstall

Plugin 'gmarik/vundle'
Plugin 'scrooloose/nerdtree'
Plugin 'Lokaltog/vim-powerline'
Plugin 'flazz/vim-colorschemes'

" NerdTree setup

autocmd VimEnter * NERDTree
autocmd VimEnter * wincmd p

" Vim setup

set laststatus=2
set backspace=indent,eol,start
filetype plugin indent on
set showmatch 
set autoindent 
set smartindent 
set hlsearch
set ai
set ruler
set tabstop=4 
set number 
set smarttab
set shiftwidth=4
set expandtab
syntax enable

" Colors 

colorscheme solarized
