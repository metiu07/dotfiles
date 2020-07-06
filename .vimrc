" TODO: Banner
" TODO: Add nvim configuration to source ~/.config/vim/vimrc

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
set rtp+=~/.tools/fzf
call vundle#begin('~/.config/vim')

" Plugins are installed with :PluginInstall
Plugin 'gmarik/vundle'
Plugin 'airblade/vim-rooter'
Plugin 'tpope/vim-fugitive'
map <leader>gg :Gstatus<CR>
Plugin 'editorconfig/editorconfig-vim'
Plugin 'itchyny/lightline.vim'
" Disabled because of: https://github.com/jiangmiao/auto-pairs/issues/272
" Plugin 'jiangmiao/auto-pairs'
Plugin 'tpope/vim-surround'
Plugin 'justinmk/vim-sneak'
" Plugin 'unblevable/quick-scope'
Plugin 'tpope/vim-commentary'
Plugin 'airblade/vim-gitgutter'
Plugin 'luochen1990/rainbow'
" Plugin 'dag/vim-fish' This plugin has wrong highting when there is a '
" escaped in the string
Plugin 'blankname/vim-fish'

" FZF
Plugin 'junegunn/fzf.vim'
command! -bang Buffers
    \ call fzf#vim#buffers({'options': ['--layout=reverse', '--info=inline']}, <bang>0)

let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'tab': 'split',
  \ 'ctrl-v': 'vsplit' }

map <leader>wc :Colors<CR>

" LSP configuration
Plugin 'prabirshrestha/asyncomplete.vim'
Plugin 'prabirshrestha/async.vim'
Plugin 'prabirshrestha/vim-lsp'
Plugin 'mattn/vim-lsp-settings'
Plugin 'liuchengxu/vista.vim' " TODO: https://github.com/neoclide/coc.nvim ??
Plugin 'prabirshrestha/asyncomplete-lsp.vim'
map gd :LspDefinition<CR>zz
map gD :LspReferences<CR>
map gh :LspHover<CR>
map gj :LspWorkspaceSymbol<CR>
map gJ :LspDocumentSymbol<CR>
" TODO: Add bindings to format the buffer and range
map <leader>ca :LspCodeAction<CR>
map <leader>cr :LspRename<CR>
map <leader>cS :LspStatus<CR>
map <leader>ch :LspHover<CR>
" TODO: Save the document before formatting
map <leader>cf :LspDocumentFormat<CR>
map <leader>cF :LspDocumentRangeFormat<CR>
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <cr>    pumvisible() ? "\<C-y>" : "\<cr>"
let g:lsp_highlights_enabled = 1
let g:lsp_textprop_enabled = 1
let g:lsp_virtual_text_enabled = 1
let g:lsp_highlight_references_enabled = 1
let g:lsp_signs_error = {'text': '✗'}
let g:lsp_signs_warning = {'text': '‼'}
let g:lsp_signs_hint = {'text': 'כֿ'}
let g:lsp_signs_information = {'text': 'כֿ'}

" TODO: Incorporate https://github.com/davidpdrsn/dotfiles/blob/master/nvim/functions.vim#L402
" TODO: Create <leader>pp

Plugin 'AndrewRadev/sideways.vim'
omap aa <Plug>SidewaysArgumentTextobjA
xmap aa <Plug>SidewaysArgumentTextobjA
omap ia <Plug>SidewaysArgumentTextobjI
xmap ia <Plug>SidewaysArgumentTextobjI

Plugin 'kana/vim-operator-user'
Plugin 'haya14busa/vim-operator-flashy'
map y <Plug>(operator-flashy)
nmap Y <Plug>(operator-flashy)$

" Plugin 'nathanaelkane/vim-indent-guides'
" let g:indent_guides_start_level = 2
" let g:indent_guides_guide_size = 1
" let g:indent_guides_enable_on_vim_startup = 1
" let g:indent_guides_auto_colors = 0
" autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  guibg=red   ctermbg=24
" autocmd VimEnter,Colorscheme * :hi IndentGuidesEven guibg=green ctermbg=30
Plugin 'thaerkh/vim-indentguides'
let g:indentguides_spacechar = '┆'
let g:indentguides_tabchar = '|'
nmap <leader>ti :IndentGuidesToggle<CR>

" Visual settings
Plugin 'mhinz/vim-startify'

" Color themes
Plugin 'YorickPeterse/happy_hacking.vim'
Plugin 'liuchengxu/space-vim-theme'
Plugin 'sonph/onehalf', {'rtp': 'vim/'}
Plugin 'joshdick/onedark.vim'
let g:onedark_terminal_italics = 1
Plugin 'arcticicestudio/nord-vim'
let g:nord_italic = 1
Plugin 'morhetz/gruvbox'
let g:gruvbox_italic = 1
let g:gruvbox_italicize_comments = 0

Plugin 's3rvac/vim-syntax-yara'

Plugin 'junegunn/goyo.vim'
map <leader>tg :Goyo<CR>

call vundle#end()
filetype plugin indent on

" Color scheme settings
if exists('+termguicolors')
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif
syntax on
" set cursorline
if !has('gui_running')
  set t_Co=256
endif
set background=dark
colorscheme gruvbox
" let g:lightline.colorscheme='onehalfdark'
let g:lightline = {
            \ 'colorscheme': 'gruvbox',
            \ }
highlight lspReference cterm=reverse,italic gui=reverse,italic

" Leader bindings
map <leader><Space> :GFiles<CR>
map <leader>. :Files<CR>
nmap <leader>< :Buffers<CR>
nmap <leader>, :Buffers<CR>
nmap <leader>/ :Rg<CR>
map <leader>x :Commands<CR>
map <leader>hk :Maps<CR>
map <leader>wc :Colors<CR>

" Splits configuration
nnoremap <leader>wh <C-W><C-H>
nnoremap <leader>wj <C-W><C-J>
nnoremap <leader>wk <C-W><C-K>
nnoremap <leader>wl <C-W><C-L>
nnoremap <leader>wH <C-W><S-H>
nnoremap <leader>wJ <C-W><S-J>
nnoremap <leader>wK <C-W><S-K>
nnoremap <leader>wL <C-W><S-L>
set splitbelow
set splitright

" General setup
set laststatus=2
set backspace=indent,eol,start
set showmatch
set autoindent
set smartindent
set smarttab
set tabstop=4
set shiftwidth=4
set expandtab
set nofoldenable
set autoread
set ttyfast
set hidden
set secure
set updatetime=100

" Numbers
set ruler
set number
" set relativenumber

" Searching
set hlsearch
set incsearch
set ignorecase
set smartcase
set gdefault

" Searches - centering
nnoremap <silent> n nzz
nnoremap <silent> N Nzz
nnoremap <silent> * *zz
nnoremap <silent> # #zz
nnoremap <silent> g* g*zz
nnoremap <silent> <C-O> <C-O>zz
" TODO: Also bind CTRL-o to center the screen

" nvim specific
if has('nvim')
    set guicursor=n-v-c-sm:hor20,i-ci-ve:ver25,r-cr-o:block
    set inccommand=nosplit
end

" TODO: Try to bind `c to nop? to avoid wrong cursor type when opening a new window

" Spell checking
set spelllang=en_us,en_gb
nnoremap <silent> <leader>ts :set spell!<CR>:set spell?<CR>

function! s:ToggleSpelllang()
	if &spelllang =~ 'en'
		set spelllang=sk
	else
		set spelllang=en_us,en_gb
	endif
	set spelllang?
endfunction
nnoremap <silent> <leader>tS :call <SID>ToggleSpelllang()<CR>

" Wildmenu
set wildmenu
set wildchar=<Tab>
set wildmode=list:longest
set wildignore+=*.o,*.obj,*.pyc,*.aux,*.bbl,*.blg,.git,.svn,.hg
set suffixes=.bak,~,.swp,.o,.info,.aux,.bbl,.blg,.brf,.cb,.ind,.idx,.ilg,.inx,.out,.toc

" Highligh incorect indenting
hi SpacesTabsMixture guifg=red guibg=gray19
match SpacesTabsMixture /^  \+\t\+[\t ]*\|^\t\+  \+[\t ]*/

" TODO: Add switch between expandtab and noexpand tab to switch between tabs
" and spaces

" Fix Y to yank until the end of line
noremap Y y$

" Fix Y to yank until the end of line
imap <M-BS> <C-W>

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

function! s:ToggleHexdumpView()
	if &filetype ==# 'xxd'
		" Turn off hexdump view.
		silent! :%!xxd -r
		set filetype=
		set binary
	else
		" Turn on hexdump view.
		silent! :%!xxd
		set filetype=xxd
		set nobinary " TODO: Maybe consider using eol and noeol
	endif
endfunction
nnoremap <silent> <Leader>th :call <SID>ToggleHexdumpView()<CR>

" Stay in visual mode when indenting.
vnoremap < <gv
vnoremap > >gv

" Save with W
cabb W w
cabb E e

" Make double-<Esc> clear search highlights
nnoremap <silent> <Esc><Esc> <Esc>:nohlsearch<CR><Esc>

augroup gitcommit
au!
au FileType gitcommit setl spell         " Enable spellchecking.
augroup end

augroup latex
au!
au FileType tex,plaintex setl spell    " Enable spell checking.
augroup end

augroup markdown
au!
au FileType markdown setl spell         " Enable spellchecking.
augroup end
