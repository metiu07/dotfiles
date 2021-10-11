" TODO: Banner
" TODO: Incorporate https://github.com/davidpdrsn/dotfiles/blob/master/nvim/functions.vim#L402
" TODO: Create <leader>pp
" TODO: Install conceal for latex https://github.com/PietroPate/vim-tex-conceal
" TODO: Checkout for toggle line numbers https://github.com/myusuf3/numbers.vim

" Set the <leader> character to spacebar
let mapleader = "\<Space>"

" Set runtimepath to same as vim
set runtimepath+=~/.config/vim/

" Plugins can be installed with :PlugInstall
call plug#begin('~/.config/vim/plugged')

" GUI
Plug 'itchyny/lightline.vim'
Plug 'yggdroot/indentline'
Plug 'mhinz/vim-startify'
Plug 'junegunn/goyo.vim'

" Tools
Plug 'junegunn/fzf.vim'
Plug 'AndrewRadev/sideways.vim'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'godlygeek/tabular'

" GIT
Plug 'airblade/vim-rooter'
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'

" LSP
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'liuchengxu/vista.vim'

" Syntax
Plug 'HerringtonDarkholme/yats.vim'
Plug 'rust-lang/rust.vim'
Plug 'blankname/vim-fish'
Plug 'udalov/kotlin-vim'
Plug 'kevinoid/vim-jsonc'
Plug 'stephpy/vim-yaml'
Plug 'cespare/vim-toml'
Plug 's3rvac/vim-syntax-yara'
Plug 'plasticboy/vim-markdown'
Plug 'axvr/org.vim'

" Flashing operations
Plug 'haya14busa/vim-operator-flashy' | Plug 'kana/vim-operator-user'

" Snippets
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'epilande/vim-react-snippets'

" Color themes
Plug 'gruvbox-community/gruvbox'

call plug#end()

" CoC
" TODO: Checkout https://github.com/neoclide/coc-pairs
" Plugin 'jiangmiao/auto-pairs'
" Disabled because of: https://github.com/jiangmiao/auto-pairs/issues/272
let g:coc_global_extensions = ['coc-json',
			\ 'coc-prettier',
			\ 'coc-clangd',
			\ 'coc-yaml',
			\ 'coc-tsserver',
			\ 'coc-snippets',
			\ 'coc-texlab',
			\ 'coc-vimlsp']
let g:coc_config_home = expand('~/.config/vim')

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)zz
nmap <silent> gy <Plug>(coc-type-definition)zz
nmap <silent> gi <Plug>(coc-implementation)zz
nmap <silent> gD <Plug>(coc-references)

" Symbol renaming.
nmap <leader>cr <Plug>(coc-rename)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')

" Formatting code.
xmap <leader>cf :Format<CR>
nmap <leader>cf :Format<CR>
" Formatting selected code.
xmap <leader>cF  <Plug>(coc-format-selected)
nmap <leader>cF  <Plug>(coc-format-selected)

" Remap keys for applying codeAction to the current buffer.
nmap <leader>ca  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>cF  <Plug>(coc-fix-current)

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>cA  <Plug>(coc-codeaction-selected)
nmap <leader>cA  <Plug>(coc-codeaction-selected)

" Map function and class text objects
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Use CTRL-S for selections ranges.
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current
" position. Coc only does snippet and additional edit on confirm.
" <cr> could be remapped by other vim plugin, try `:verbose imap <CR>`.
if exists('*complete_info')
  inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
else
  inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
endif

" Mappings for CoCList
" Show all diagnostics.
nnoremap <silent><nowait> <leader>Ca  :<C-u>CocList diagnostics<cr>
" Manage extensions.
nnoremap <silent><nowait> <leader>Ce  :<C-u>CocList extensions<cr>
" Show commands.
nnoremap <silent><nowait> <leader>Cc  :<C-u>CocList commands<cr>
" Find symbol of current document.
nnoremap <silent><nowait> <leader>Co  :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent><nowait> <leader>Cs  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent><nowait> <leader>Cj  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent><nowait> <leader>Ck  :<C-u>CocPrev<CR>
" Resume latest coc list.
nnoremap <silent><nowait> <leader>Cp  :<C-u>CocListResume<CR>

" Goyo
" TODO: Also toggle wrapping with this command
map <leader>tg :Goyo<CR>

" Fugitive
map <leader>gg :Git<CR>
map <leader>gb :Git blame<CR>
map <leader>gl :Git log --oneline<CR>

" Vista
let g:vista_default_executive = 'vim_lsp'
" Ignore module symbols, they are not relevant and only polute the search list
let g:vista_ignore_kinds = ['Module']
map gj :Vista finder<CR>

" Gitgutter
let g:gitgutter_set_sign_backgrounds = 1
highlight SignColumn ctermbg=NONE gui=NONE guibg=NONE

" FZF
let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'tab': 'split',
  \ 'ctrl-v': 'vsplit' }
let g:fzf_preview_window = 'up:60%'

" Indent guides
let g:indentLine_fileTypeExclude = ['markdown', 'jsonc']
nmap <leader>ti :IndentLinesToggle<CR>

" Vim operator flashy
map y <Plug>(operator-flashy)
nmap Y <Plug>(operator-flashy)$

" Sideways
omap aa <Plug>SidewaysArgumentTextobjA
xmap aa <Plug>SidewaysArgumentTextobjA
omap ia <Plug>SidewaysArgumentTextobjI
xmap ia <Plug>SidewaysArgumentTextobjI
nnoremap <c-h> :SidewaysLeft<cr>
nnoremap <c-l> :SidewaysRight<cr>

" Color scheme settings
syntax on
if exists('+termguicolors')
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif
let g:gruvbox_bold = 1
let g:gruvbox_italic = 1
let g:gruvbox_italicize_comments = 0
let g:gruvbox_undercurl = 0
" Needed for spell
let g:gruvbox_guisp_fallback = "bg"
colorscheme gruvbox
let g:lightline = { 'colorscheme': 'gruvbox' }

" Fix the annoying syntax bug when scrolling. This can be slow for large
" files, but is always accurate. In case of performance problems consider
" restricting this only to particular file types.
" Ref: https://vim.fandom.com/wiki/Fix_syntax_highlighting
autocmd BufEnter * :syntax sync fromstart

" set cursorline
if !has('gui_running')
  set t_Co=256
endif
set background=dark

" Disable background - transparency
"
" highlight Normal ctermbg=NONE gui=NONE guibg=NONE
" highlight nonText ctermbg=NONE gui=NONE guibg=NONE

" Leader bindings
map <leader><Space> :GFiles<CR>
map <leader>. :Files<CR>
nmap <leader>< :Buffers<CR>
nmap <leader>, :Buffers<CR>
nmap <leader>/ :Rg<CR>
map <leader>x :Commands<CR>
map <leader>hk :Maps<CR>
map <leader>wc :Colors<CR>

" Clipboard
vnoremap <leader>y "+y
vnoremap <leader>Y "*y
nnoremap <leader>y "+y
nnoremap <leader>yy "+yy
nnoremap <leader>p "+p
vnoremap <leader>x "+x
nnoremap <leader>x "+x

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
" If in insert mode, don't enable the mouse
" This causes the paste to paste directly at the text cursor
" instead moving to mouse cursor coordinates and then pasting
set mouse=nvch

" Numbers
set ruler
set number
" set relativenumber

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

" Make double-<Esc> clear search highlights
nnoremap <silent> <Esc><Esc> <Esc>:nohlsearch<CR><Esc>

" Stay in visual mode when indenting.
vnoremap < <gv
vnoremap > >gv

" Aliases - Save with W
cabb E e
cabb Q w
cabb W w

" Searches - centering
nnoremap <silent> n nzz
nnoremap <silent> N Nzz
nnoremap <silent> * *zz
nnoremap <silent> # #zz
nnoremap <silent> g* g*zz
nnoremap <silent> <C-O> <C-O>zz
" TODO: Also bind CTRL-o to center the screen

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

" Formatting
nnoremap Q vapgq

" https://coreyja.com/vim-spelling-suggestions-fzf/
function! FzfSpellSink(word)
  exe 'normal! "_ciw'.a:word
endfunction
function! FzfSpell()
  let suggestions = spellsuggest(expand("<cword>"))
  return fzf#run({'source': suggestions, 'sink': function("FzfSpellSink"), 'down': 10 })
endfunction
nnoremap z= :call FzfSpell()<CR>

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

augroup gitcommit
au!
au FileType gitcommit setl spell         " Enable spellchecking.
augroup end

augroup latex
au!
au FileType tex,plaintex setl spell    " Enable spell checking.
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
au BufRead,BufNewFile *.tex setl textwidth=80
augroup end
