" Vundle setup
set nocompatible
filetype off
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

" Plugins to be installed with :PluginInstall

Plugin 'gmarik/vundle'
Plugin 'scrooloose/nerdtree'
Plugin 'Lokaltog/vim-powerline'
Plugin 'altercation/vim-colors-solarized'
Plugin 'scrooloose/syntastic'

" Syntastic setup

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

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

set background=dark
colorscheme solarized
