" TODO: Banner

" For Vundle -> fish is not compatible
if &shell =~# 'fish$'
    set shell=sh
endif

" Set the <leader> character
let mapleader = "\<Space>"

" Vundle setup
set nocompatible
filetype off
set rtp+=~/.config/vim/bundle/Vundle.vim
call vundle#begin('~/.config/vim')

" Plugins are installed with :PluginInstall
Plugin 'gmarik/vundle'
Plugin 'airblade/vim-rooter'
Plugin 'junegunn/fzf.vim'
Plugin 'itchyny/lightline.vim'
Plugin 'jiangmiao/auto-pairs'
Plugin 'tpope/vim-surround'
Plugin 'scrooloose/nerdcommenter'
Plugin 'airblade/vim-gitgutter'
Plugin 'luochen1990/rainbow'


" LSP configuration
Plugin 'prabirshrestha/async.vim'
Plugin 'prabirshrestha/vim-lsp'
Plugin 'mattn/vim-lsp-settings'
map gd :LspDefinition<CR>
map <leader>ca :LspCodeAction<CR>
let g:lsp_highlights_enabled = 1
let g:lsp_textprop_enabled = 1
let g:lsp_virtual_text_enabled = 1
let g:lsp_highlight_references_enabled = 1
highlight lspReference ctermfg=red guifg=red ctermbg=green guibg=green

" Plugin 'scrooloose/syntastic'
" set statusline+=%#warningmsg#
" set statusline+=%{SyntasticStatuslineFlag()}
" set statusline+=%*
" let g:syntastic_always_populate_loc_list = 1
" let g:syntastic_auto_loc_list = 1
" let g:syntastic_check_on_open = 1
" let g:syntastic_check_on_wq = 0

Plugin 'AndrewRadev/sideways.vim'
omap aa <Plug>SidewaysArgumentTextobjA
xmap aa <Plug>SidewaysArgumentTextobjA
omap ia <Plug>SidewaysArgumentTextobjI
xmap ia <Plug>SidewaysArgumentTextobjI

Plugin 'kana/vim-operator-user'
Plugin 'haya14busa/vim-operator-flashy'
map y <Plug>(operator-flashy)
nmap Y <Plug>(operator-flashy)$

call vundle#end()
filetype plugin indent on

" Leader bindings
map <leader><Space> :GFiles<CR>
map <leader>. :Files<CR>
nmap <leader>< :Buffers<CR>
nmap <leader>/ :Rg<CR>
map <leader>x :Commands<CR>

" Splits configuration
nnoremap <leader>wh <C-W><C-H>
nnoremap <leader>wj <C-W><C-J>
nnoremap <leader>wk <C-W><C-K>
nnoremap <leader>wl <C-W><C-L>
set splitbelow
set splitright

" General setup
set laststatus=2
set backspace=indent,eol,start
set showmatch
set autoindent 
set smartindent
set smarttab
set hlsearch
set autoindent
set ruler
set relativenumber
set tabstop=4
set shiftwidth=4
set expandtab
set nofoldenable
set autoread
set incsearch
set ttyfast
set secure
set ignorecase
set smartcase
syntax enable

" Wildmenu
set wildmenu
set wildchar=<Tab>
set wildmode=list:longest
set wildignore+=*.o,*.obj,*.pyc,*.aux,*.bbl,*.blg,.git,.svn,.hg
set suffixes=.bak,~,.swp,.o,.info,.aux,.bbl,.blg,.brf,.cb,.ind,.idx,.ilg,.inx,.out,.toc

" Highligh incorect indenting
hi SpacesTabsMixture guifg=red guibg=gray19
match SpacesTabsMixture /^  \+\t\+[\t ]*\|^\t\+  \+[\t ]*/

" Fix Y to yank until the end of line
noremap Y y$

" Function to toggle betwen wraping and notwrapping lines
noremap <silent> <Leader>tw :call ToggleWrap()<CR>
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
