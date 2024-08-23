" TODO: Banner
" TODO: Incorporate https://github.com/davidpdrsn/dotfiles/blob/master/nvim/functions.vim#L402
" TODO: Create <leader>pp
" TODO: Install conceal for latex https://github.com/PietroPate/vim-tex-conceal
" TODO: Checkout for toggle line numbers https://github.com/myusuf3/numbers.vim

" Set the <leader> character to spacebar
let mapleader = "\<Space>"

" My old wrong colemak - set langmap=hm,mh,ek,fe,il,jy,kn,lu,nj,pr,rs,sd,tf,ui,yo,op,bt,dv,vb,HM,UI,DV,EK,FE,IL,JY,KN,LU,NJ,PR,RS,SD,TF,UI,YO,OP
set langmap=zb,xz,cx,dc,hm,mh,ek,fe,il,jy,kn,lu,nj,pr,rs,sd,tf,ui,yo,op,bt,XZ,CX,DC,ZB,HM,UI,EK,FE,IL,JY,KN,LU,NJ,PR,RS,SD,TF,UI,YO,OP
nmap <c-p> :redo<cr>
" Page down
nnoremap <c-l> <c-u>
vnoremap <c-l> <c-u>
" Page up
nnoremap <c-s> <c-d>
vnoremap <c-s> <c-d>
" Block select
nnoremap <c-d> <c-v>

if has('termguicolors')
  set termguicolors
endif

" Make
nnoremap <F1> :make<CR>
nnoremap <leader>r :make<CR>

" Clipboard
vnoremap <leader>y "+y
vnoremap <leader>Y "*y
nnoremap <leader>y "+y
nnoremap <leader>yy "+yy
nnoremap <leader>p "+p
vnoremap <leader>x "+x
nnoremap <leader>x "+x

" Unbind K in visual selection mode
xnoremap K <Nop>

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
set smarttab
set tabstop=4
set shiftwidth=4
set expandtab
set nofoldenable
set autoread
set ttyfast
set hidden
set secure
set spell
set updatetime=100
" If in insert mode, don't enable the mouse
" This causes the paste to paste directly at the text cursor
" instead moving to mouse cursor coordinates and then pasting
set mouse=nvch

" Numbers
set ruler
set number
set scrolloff=10

" Backups & Undo
set backup
set backupdir=~/.config/vim/tmp/backup/
set backupskip=/tmp/*,/private/tmp/*
set noswapfile
set history=1000
set undodir=~/.config/vim/tmp/undo/
set undofile
set undolevels=1000
set writebackup

" Wildmenu
set wildmenu
set wildchar=<Tab>
set wildmode=list:longest
set wildignore+=*.o,*.obj,*.pyc,*.aux,*.bbl,*.blg,.git,.svn,.hg
set suffixes=.bak,~,.swp,.o,.info,.aux,.bbl,.blg,.brf,.cb,.ind,.idx,.ilg,.inx,.out,.toc

" Searching
set hlsearch
set incsearch
set ignorecase
set smartcase
set gdefault

" List
set listchars=nbsp:+,tab:>\ ,trail:·,extends:>,lead:·

" Make double-<Esc> clear search highlights
" nnoremap <silent> <Esc><Esc> <Esc>:nohlsearch<CR><Esc>

" Stay in visual mode when indenting.
vnoremap < <gv
vnoremap > >gv

" Aliases - Save with W
cabb E e
cabb Q q
cabb W w

" Nvim specific
if has('nvim')
    set guicursor=n-v-c-sm:hor20,i-ci-ve:ver25,r-cr-o:block
    set inccommand=nosplit
end

" TODO: Try to bind `c to nop? to avoid wrong cursor type when opening a new window

" Set the dockerfile filetype for every file that starts with Dockerfile
" For example: Dockerfile.backend, Dockerfile.frontend
autocmd BufNewFile,BufRead Dockerfile* set filetype=dockerfile

" Conceal
function! ToggleConcealLevel()
    if &conceallevel == 0
        setlocal conceallevel=2
    else
        setlocal conceallevel=0
    endif
endfunction
nnoremap <silent> <leader>tc :call ToggleConcealLevel()<CR>

" Spell checking
set spelllang=en_us,en_gb
nnoremap <silent> <leader>ts :set spell!<CR>:set spell?<CR>

" Correct the last spelling error
inoremap <C-l> <C-g>u<ESC>[s1z=`]a<C-g>u

function! s:ToggleSpelllang()
	if &spelllang =~ 'en'
		set spelllang=sk
	else
		set spelllang=en_us,en_gb
	endif
	set spelllang?
endfunction
nnoremap <silent> <leader>tS :call <SID>ToggleSpelllang()<CR>

" Open last buffer using backspace
nnoremap <BS> <C-^>

" Formatting
nnoremap Q vapgw

" Highligh incorect indenting
" hi SpacesTabsMixture guifg=red guibg=gray19
" match SpacesTabsMixture /^  \+\t\+[\t ]*\|^\t\+  \+[\t ]*/

" TODO: Add switch between expandtab and noexpand tab to switch between tabs
" and spaces

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

" Function to toggle hexdump view
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

augroup rust
au!
au FileType rust setl makeprg=cargo\ test
augroup end

augroup gitcommit
au!
au FileType gitcommit setl spell         " Enable spellchecking.
augroup end

augroup latex
au!
au FileType tex,plaintex setl spell    " Enable spellchecking.
au BufRead,BufNewFile *.tex setl textwidth=80
augroup end

augroup markdown
au!
au FileType markdown setl spell         " Enable spellchecking.
au BufRead,BufNewFile *.md setl textwidth=80
augroup end

autocmd BufNewFile,BufRead *.yar,*.yara set filetype=yara
augroup yara
au!
au FileType yara setl expandtab
augroup end

autocmd BufNewFile,BufRead */waybar/config set filetype=jsonc
