" Vundle setup
set nocompatible
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" Plugins are installed with :PluginInstall

Plugin 'gmarik/vundle'
Plugin 'scrooloose/nerdtree'
Plugin 'Lokaltog/vim-powerline'
Plugin 'flazz/vim-colorschemes'
Plugin 'ervandew/supertab'
Plugin 'jiangmiao/auto-pairs'
Plugin 'jlanzarotta/bufexplorer'
Plugin 'tpope/vim-fugitive'
<<<<<<< HEAD
Plugin 'tpope/vim-surround'

=======
Plugin 'godlygeek/tabular'
Plugin 'plasticboy/vim-markdown'
Plugin 'mattn/emmet-vim'
Plugin 'ahw/vim-hooks'
Plugin 'tpope/vim-surround'
Plugin 'rodjek/vim-puppet'
Plugin 'scrooloose/nerdcommenter'
>>>>>>> 728af5366de3f36f2924025c5d184ff7955a309f

call vundle#end()

" NerdTree setup

" autocmd VimEnter * NERDTree
" autocmd VimEnter * wincmd p

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
set nofoldenable
set autoread
set incsearch
syntax enable

let g:netrw_liststyle=3

autocmd BufWritePost *.md :call SaveAndMake()
nnoremap <leader>m call SaveAndMake()<CR>
function SaveAndMake()
   silent! make
   :w
   redraw!
   redraw!
endfunction

" Function to toggle betwen wraping and notwrapping lines
noremap <silent> <Leader>w :call ToggleWrap()<CR>
function ToggleWrap()
  if &wrap
    echo "Wrap OFF"
    setlocal nowrap
    set virtualedit=all
    silent! nunmap <buffer> <Up>
    silent! nunmap <buffer> <Down>
    silent! nunmap <buffer> <Home>
    silent! nunmap <buffer> <End>
    silent! iunmap <buffer> <Up>
    silent! iunmap <buffer> <Down>
    silent! iunmap <buffer> <Home>
    silent! iunmap <buffer> <End>
    silent! nunmap  <buffer> <silent> k
    silent! nunmap  <buffer> <silent> j
    silent! nunmap  <buffer> <silent> 0
    silent! nunmap  <buffer> <silent> $
  else
    echo "Wrap ON"
    setlocal wrap linebreak nolist
    set virtualedit=
    setlocal display+=lastline
    noremap  <buffer> <silent> <Up>   gk
    noremap  <buffer> <silent> <Down> gj
    noremap  <buffer> <silent> <Home> g<Home>
    noremap  <buffer> <silent> <End>  g<End>
    noremap  <buffer> <silent> k gk
    noremap  <buffer> <silent> j gj
    noremap  <buffer> <silent> 0 g0
    noremap  <buffer> <silent> $ g$
    inoremap <buffer> <silent> <Up>   <C-o>gk
    inoremap <buffer> <silent> <Down> <C-o>gj
    inoremap <buffer> <silent> <Home> <C-o>g<Home>
    inoremap <buffer> <silent> <End>  <C-o>g<End>
  endif
endfunction
silent call ToggleWrap()
