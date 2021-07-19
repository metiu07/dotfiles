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
" TODO:Isolate the plugins directory from the configuration directory.
" If `rtp` dir contains also other files/folders that are not directly plugins
" and the '+PluginClean' is executed it will also remove all files that are
" not explicitly listed in this configuration as plugins (backups, undo,
" coc_config).
call vundle#begin('~/.config/vim')

" Plugins can be installed with :PluginInstall
Plugin 'gmarik/vundle'
Plugin 'airblade/vim-rooter'
Plugin 'tpope/vim-fugitive'
map <leader>gg :Git<CR>
map <leader>gb :Git blame<CR>
map <leader>gl :Git log --oneline<CR>
Plugin 'editorconfig/editorconfig-vim'
Plugin 'itchyny/lightline.vim'
Plugin 'tpope/vim-surround'
Plugin 'godlygeek/tabular'
Plugin 'justinmk/vim-sneak'
Plugin 'liuchengxu/vista.vim'
let g:vista_default_executive = 'vim_lsp'
" Ignore module symbols, they are not relevant and only polute the search list
let g:vista_ignore_kinds = ['Module']
map gj :Vista finder<CR>
" Plugin 'unblevable/quick-scope'
Plugin 'tpope/vim-commentary'
Plugin 'airblade/vim-gitgutter'
let g:gitgutter_set_sign_backgrounds = 1
highlight SignColumn ctermbg=NONE gui=NONE guibg=NONE
Plugin 'luochen1990/rainbow'
" Plugin 'dag/vim-fish' This plugin has wrong highting when there is a '
" escaped in the string
Plugin 'blankname/vim-fish'
Plugin 'udalov/kotlin-vim'
Plugin 'kevinoid/vim-jsonc'
Plugin 'stephpy/vim-yaml'
Plugin 'cespare/vim-toml'
Plugin 'plasticboy/vim-markdown'
"TODO: Install conceal for latex https://github.com/PietroPate/vim-tex-conceal
"TODO: Checkout for toggle line numbers https://github.com/myusuf3/numbers.vim

" Typescript
Plugin 'HerringtonDarkholme/yats.vim'
" Plugin 'pangloss/vim-javascript'
" Plugin 'neoclide/vim-jsx-improve'
" Plugin 'leafgarland/typescript-vim'
" Plugin 'peitalin/vim-jsx-typescript'
" set filetypes as typescriptreact
" autocmd BufNewFile,BufRead *.tsx,*.jsx set filetype=typescriptreact
Plugin 'axvr/org.vim'

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

" Debugging
" Plugin 'puremourning/vimspector'
" let g:vimspector_enable_mappings = 'HUMAN'

" CoC
" TODO: Checkout https://github.com/neoclide/coc-pairs
" Plugin 'jiangmiao/auto-pairs'
" Disabled because of: https://github.com/jiangmiao/auto-pairs/issues/272
Plugin 'neoclide/coc.nvim', {'branch': 'release'}
let g:coc_global_extensions = ['coc-json',
			\ 'coc-prettier',
			\ 'coc-clangd',
			\ 'coc-yaml',
			\ 'coc-tsserver',
			\ 'coc-rust-analyzer',
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

" TODO: Incorporate https://github.com/davidpdrsn/dotfiles/blob/master/nvim/functions.vim#L402
" TODO: Create <leader>pp

Plugin 'AndrewRadev/sideways.vim'
omap aa <Plug>SidewaysArgumentTextobjA
xmap aa <Plug>SidewaysArgumentTextobjA
omap ia <Plug>SidewaysArgumentTextobjI
xmap ia <Plug>SidewaysArgumentTextobjI

" Snippets
" Plugin 'SirVer/ultisnips'
" Plugin 'honza/vim-snippets'
" let g:UltiSnipsExpandTrigger="<tab>"
" let g:UltiSnipsJumpForwardTrigger="<c-n>"
" let g:UltiSnipsJumpBackwardTrigger="<c-p>"

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
Plugin 'humanoid-colors/vim-humanoid-colorscheme'
Plugin 'haishanh/night-owl.vim'
Plugin 'ghifarit53/tokyonight-vim'
Plugin 'chriskempson/base16-vim'
Plugin 'sjl/badwolf'
Plugin 'nanotech/jellybeans.vim'
Plugin 'YorickPeterse/happy_hacking.vim'
Plugin 'tomasr/molokai'
let g:rehash256 = 1
Plugin 'dracula/vim', { 'name': 'dracula' }
Plugin 'liuchengxu/space-vim-theme'
Plugin 'sonph/onehalf', {'rtp': 'vim/'}
Plugin 'joshdick/onedark.vim'
let g:onedark_terminal_italics = 1
Plugin 'arcticicestudio/nord-vim'
let g:nord_italic = 1
" Plugin 'morhetz/gruvbox'
Plugin 'gruvbox-community/gruvbox'
let g:gruvbox_italic = 1
let g:gruvbox_italicize_comments = 0
let g:gruvbox_undercurl = 0

Plugin 's3rvac/vim-syntax-yara'

Plugin 'junegunn/goyo.vim'
" TODO: Also toggle wrapping with this command
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

color gruvbox

" TODO: Create function to change the whole colorscheme not only the editor
" but also lightline, etc.
" TODO: Research ColorScheme event (:help au + search event) and set the
" lightline
" https://github.com/itchyny/lightline.vim/issues/9
" https://hiphish.github.io/blog/2019/09/21/switching-automatically-themes-in-lightline/

" Disable background - transparency
"
" highlight Normal ctermbg=NONE gui=NONE guibg=NONE
" highlight nonText ctermbg=NONE gui=NONE guibg=NONE

" Gruvbox spell in terminal is not supported, modify it
" TODO: Better colors
highlight SpellCap cterm=undercurl gui=undercurl guifg=green
highlight SpellBad cterm=undercurl gui=undercurl guifg=red guisp=red
highlight SpellLocal cterm=undercurl gui=undercurl
highlight SpellRare cterm=undercurl gui=undercurl guifg=blue

let g:lightline = { 'colorscheme': 'gruvbox' }


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
" set expandtab
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

" Save with W
cabb W w
cabb E e

" Fix Y to yank until the end of line
noremap Y y$
" TODO: Is this correct?
imap <M-BS> <C-W>

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

autocmd BufNewFile,BufRead *.yar,*.yara set filetype=yara

" Set the dockerfile filetype for every file that starts with Dockerfile
" For example: Dockerfile.backend, Dockerfile.frontend
autocmd BufNewFile,BufRead Dockerfile* set filetype=dockerfile

" Conceal
"
" By default be more explicit
function! ToggleConcealLevel()
    if &conceallevel == 0
        setlocal conceallevel=2
    else
        setlocal conceallevel=0
    endif
endfunction

nnoremap <silent> <leader>tc :call ToggleConcealLevel()<CR>
" TODO: Check out https://github.com/thaerkh/vim-indentguides/pull/22
" Plugin thaerkh/vim-indentguides is forcing higher conceallevel
set conceallevel=0
set concealcursor=""
au FileType * setl conceallevel=0

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
au BufRead,BufNewFile *.tex setlocal textwidth=80
augroup end

augroup markdown
au!
au FileType markdown setl spell         " Enable spellchecking.
au BufRead,BufNewFile *.md setlocal textwidth=80
augroup end
