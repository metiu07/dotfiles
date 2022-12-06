local ensure_packer = function()
    local fn = vim.fn
    local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
    if fn.empty(fn.glob(install_path)) > 0 then
        fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path })
        vim.cmd [[packadd packer.nvim]]
        return true
    end
    return false
end

local packer_bootstrap = ensure_packer()

-- FIXME: Dynamically find the path to the config
vim.cmd('source ~/.config/nvim/config.vim')

require('packer').startup(function(use)
    use 'wbthomason/packer.nvim'

    -- TODO: Consider https://github.com/ziontee113/syntax-tree-surfer

    use {
        'nvim-lualine/lualine.nvim',
        requires = { 'kyazdani42/nvim-web-devicons', opt = true }
    }
    use "lukas-reineke/indent-blankline.nvim"

    -- Tools
    -- FIXME: We can maybe replace with https://github.com/nvim-treesitter/nvim-treesitter-textobjects
    use 'AndrewRadev/sideways.vim'
    use 'tpope/vim-commentary'
    use {
        'nvim-telescope/telescope.nvim', tag = '0.1.0',
        requires = { { 'nvim-lua/plenary.nvim' } }
    }

    -- GIT
    use 'airblade/vim-rooter'
    use 'tpope/vim-fugitive'
    use 'airblade/vim-gitgutter'

    -- LSP
    use 'neovim/nvim-lspconfig'

    -- Syntax
    use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
    use { 's3rvac/vim-syntax-yara', ft = "yara" }

    -- Flashing operations
    use 'haya14busa/vim-operator-flashy'
    use 'kana/vim-operator-user'

    -- Color themes
    use 'gruvbox-community/gruvbox'

    if packer_bootstrap then
        require('packer').sync()
    end

end)

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader><leader>', builtin.find_files, {})
vim.keymap.set('n', '<leader>/', builtin.live_grep, {})
vim.keymap.set('n', '<leader>,', builtin.buffers, {})
vim.keymap.set('n', '<leader>mm', builtin.help_tags, {})
vim.keymap.set('n', '<leader>mk', builtin.keymaps, {})
vim.keymap.set('n', '<leader>x', builtin.commands, {})

-- Fugitive
vim.keymap.set('n', '<leader>gg', "<cmd>Git<CR>", {})
vim.keymap.set('n', '<leader>gb', "<cmd>Git blame<CR>", {})
vim.keymap.set('n', '<leader>gl', "<cmd>Git log --oneline <CR>", {})

-- " Gitgutter
-- FIXME: Convert to lua
vim.cmd([[
let g:gitgutter_set_sign_backgrounds = 1
highlight SignColumn ctermbg=NONE gui=NONE guibg=NONE
]])

-- Highlight yanked things
-- FIXME: Convert to lua
vim.cmd([[
augroup highlight_yank
    autocmd!
    au TextYankPost * silent! lua vim.highlight.on_yank{higroup="IncSearch", timeout=50}
augroup END
]])

-- Indent blankline
vim.api.nvim_set_var("indent_blankline_char", "¦")
vim.api.nvim_set_var("indent_blankline_filetype_exclude", { 'markdown', 'jsonc', 'json' })
vim.api.nvim_set_var("indent_blankline_char_blankline", '')

-- Sideways
-- FIXME: Convert to lua
vim.cmd([[
omap aa <Plug>SidewaysArgumentTextobjA
xmap aa <Plug>SidewaysArgumentTextobjA
omap ia <Plug>SidewaysArgumentTextobjI
xmap ia <Plug>SidewaysArgumentTextobjI
]])

-- Treesitter
require 'nvim-treesitter.configs'.setup {
    ensure_installed = { "c", "lua", "rust", "fish", "javascript", "typescript" },
    sync_install = false,
    auto_install = true,
    highlight = {
        enable = true,
    },
}

-- LSP
local opts = { noremap = true, silent = true }
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[g', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']g', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, opts)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
---@diagnostic disable-next-line: unused-local
local on_attach = function(client, bufnr)
    print("LSP server attached")
    -- Enable completion triggered by <c-x><c-o>
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

    -- Mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local bufopts = { noremap = true, silent = true, buffer = bufnr }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
    vim.keymap.set('n', '<space>Wa', vim.lsp.buf.add_workspace_folder, bufopts)
    vim.keymap.set('n', '<space>Wr', vim.lsp.buf.remove_workspace_folder, bufopts)
    vim.keymap.set('n', '<space>Wl', function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, bufopts)
    vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
    vim.keymap.set('n', '<space>cp', vim.lsp.buf.rename, bufopts)
    vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
    vim.keymap.set('n', '<space>f', function()
        print("Formatting")
        vim.lsp.buf.format { async = true }
    end, bufopts)

    -- Automatic formatting on save
    vim.cmd("autocmd BufWritePre <buffer> lua vim.lsp.buf.format()")
end

require('lspconfig')['pyright'].setup {
    on_attach = on_attach,
}
require('lspconfig')['tsserver'].setup {
    on_attach = on_attach,
}
require('lspconfig')['sumneko_lua'].setup {
    on_attach = on_attach,
    settings = {
        Lua = {
            runtime = {
                -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                version = 'LuaJIT',
            },
            diagnostics = {
                -- Get the language server to recognize the `vim` global
                globals = { 'vim' },
            },
            workspace = {
                -- Make the server aware of Neovim runtime files
                library = vim.api.nvim_get_runtime_file("", true),
                checkThirdParty = false,
            },
            -- Do not send telemetry data containing a randomized but unique identifier
            telemetry = {
                enable = false,
            },
        },
    },
}
require('lspconfig')['rust_analyzer'].setup {
    on_attach = on_attach,
    -- Server-specific settings...
    settings = {
        ["rust-analyzer"] = {}
    }
}
