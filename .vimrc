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
Plugin 'liuchengxu/vista.vim'
let g:vista_default_executive = 'vim_lsp'
map gj :Vista finder<CR>
" Plugin 'unblevable/quick-scope'
Plugin 'tpope/vim-commentary'
Plugin 'airblade/vim-gitgutter'
Plugin 'luochen1990/rainbow'
" Plugin 'dag/vim-fish' This plugin has wrong highting when there is a '
" escaped in the string
Plugin 'blankname/vim-fish'

" FZF
Plugin 'junegunn/fzf.vim'
" \ call fzf#vim#buffers({'options': ['--info=inline']}, <bang>0)
" command! -bang Buffers
" \ call fzf#vim#buffers(<q-args>, fzf#vim#with_preview({'options': ['--layout=reverse', '--info=inline']}), <bang>0)

let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'tab': 'split',
  \ 'ctrl-v': 'vsplit' }

" let g:fzf_layout = { 'window': { 'width': 0.8, 'height': 0.8 } }
" let g:fzf_layout = { 'window': 'enew' }
" let g:fzf_layout = { 'window': '-tabnew' }
" let g:fzf_layout = { 'window': '100split enew' } " 100 lines
" let g:fzf_layout = { 'down': '40%' }
" let g:fzf_layout = { 'down': '~40%' }
let g:fzf_preview_window = 'up:60%'

" LSP configuration
" TODO: Save the document before formatting?
" vim-lsp
" Plugin 'prabirshrestha/asyncomplete.vim'
" Plugin 'prabirshrestha/async.vim'
" Plugin 'prabirshrestha/vim-lsp'
" Plugin 'mattn/vim-lsp-settings'
" Plugin 'prabirshrestha/asyncomplete-lsp.vim'
" map gd :LspDefinition<CR>zz
" map gD :LspReferences<CR>
" map gh :LspHover<CR>
" map gj :LspWorkspaceSymbol<CR>
" map gJ :LspDocumentSymbol<CR>
" map <leader>ca :LspCodeAction<CR>
" map <leader>cr :LspRename<CR>
" map <leader>cS :LspStatus<CR>
" map <leader>ch :LspHover<CR>
" map <leader>cf :LspDocumentFormat<CR>
" map <leader>cF :LspDocumentRangeFormat<CR>
" inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
" inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
" inoremap <expr> <cr>    pumvisible() ? "\<C-y>" : "\<cr>"
" let g:lsp_highlights_enabled = 1
" let g:lsp_textprop_enabled = 1
" let g:lsp_virtual_text_enabled = 1
" let g:lsp_highlight_references_enabled = 1
" let g:lsp_signs_error = {'text': '✗'}
" let g:lsp_signs_warning = {'text': '‼'}
" let g:lsp_signs_hint = {'text': 'כֿ'}
" let g:lsp_signs_information = {'text': 'כֿ'}
" " vim-lsp debugging
" let g:lsp_log_verbose = 1
" let g:lsp_log_file = expand('~/.config/vim/vim-lsp.log')

" CoC
Plugin 'neoclide/coc.nvim', {'branch': 'release'}
let g:coc_config_home = expand('~/.config/vim/coc-config.json')
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
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Use CTRL-S for selections ranges.
" Requires 'textDocument/selectionRange' support of LS, ex: coc-tsserver
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
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

inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
      let col = col('.') - 1
      return !col || getline('.')[col - 1]  =~# '\s'
endfunction

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
