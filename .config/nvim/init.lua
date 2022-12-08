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

-- Gruvbox
vim.g.gruvbox_baby_use_original_palette = 1
vim.cmd('colorscheme gruvbox-baby')

require('packer').startup(function(use)
    use 'wbthomason/packer.nvim'

    -- TODO: Consider https://github.com/ziontee113/syntax-tree-surfer
    -- TODO: Consider https://github.com/windwp/nvim-autopairs

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

    use 'ethanholz/nvim-lastplace'

    -- GIT
    -- TODO: Consider https://github.com/ahmedkhalf/project.nvim
    use 'airblade/vim-rooter'
    use 'tpope/vim-fugitive'
    use 'lewis6991/gitsigns.nvim'

    -- LSP
    use 'neovim/nvim-lspconfig'

    -- Completion
    use 'L3MON4D3/LuaSnip'
    use 'saadparwaiz1/cmp_luasnip'
    use 'hrsh7th/cmp-nvim-lsp'
    use 'hrsh7th/cmp-buffer'
    use 'hrsh7th/cmp-path'
    use 'hrsh7th/cmp-cmdline'
    use 'hrsh7th/nvim-cmp'
    use 'onsails/lspkind.nvim'

    use {
        "danymat/neogen",
        config = function()
            require('neogen').setup {}
        end,
        requires = "nvim-treesitter/nvim-treesitter",
    }

    -- Syntax
    use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
    use { 's3rvac/vim-syntax-yara', ft = "yara" }

    -- Flashing operations
    use 'haya14busa/vim-operator-flashy'
    use 'kana/vim-operator-user'

    -- Color themes
    use 'gruvbox-community/gruvbox'
    use 'luisiacc/gruvbox-baby'

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

-- Gitsigns
require('gitsigns').setup()

-- Lastplace
require('nvim-lastplace').setup {
    lastplace_ignore_buftype = { "quickfix", "nofile", "help" },
    lastplace_ignore_filetype = { "gitcommit", "gitrebase", "svn", "hgcommit" },
}

-- Neogen
local opts = { noremap = true, silent = true }
vim.api.nvim_set_keymap("n", "<Leader>nf", ":lua require('neogen').generate()<CR>", opts)

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

-- Lualine
require('lualine').setup { theme = 'gruvbox-baby' }

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
    ensure_installed = { "c", "diff", "gitcommit", "lua", "rust", "fish", "javascript", "typescript" },
    sync_install = false,
    auto_install = true,
    highlight = {
        enable = true,
    },
}

-- Completion
vim.opt.completeopt = { 'menu', 'menuone', 'noselect' }

-- Set up nvim-cmp.
local has_words_before = function()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local luasnip = require("luasnip")
local cmp = require("cmp")
local lspkind = require('lspkind')

cmp.setup({
    formatting = {
        format = lspkind.cmp_format({
            mode = 'symbol',
        }),
    },
    experimental = {
        ghost_text = true
    },
    snippet = {
        expand = function(args)
            require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
        end,
    },
    window = {
        -- completion = cmp.config.window.bordered(),
        -- documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
        ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            elseif has_words_before() then
                cmp.complete()
            else
                fallback()
            end
        end, { "i", "s" }),

        ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { "i", "s" }),
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
    }, {
        { name = 'buffer' },
    })
})

-- Set configuration for specific filetype.
cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources({
        { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
    }, {
        { name = 'buffer' },
    })
})

-- -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
-- cmp.setup.cmdline({ '/', '?' }, {
--     mapping = cmp.mapping.preset.cmdline(),
--     sources = {
--         { name = 'buffer' }
--     }
-- })

-- -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
-- cmp.setup.cmdline(':', {
--     mapping = cmp.mapping.preset.cmdline(),
--     sources = cmp.config.sources({
--         { name = 'path' }
--     }, {
--         { name = 'cmdline' }
--     })
-- })

-- Set up lspconfig.
local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- LSP
local opts = { noremap = true, silent = true }
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[g', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']g', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, opts)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(_, bufnr)
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
    -- FIXME: Add a way to distinguish between read/write
    vim.cmd([[
    " hi default link LspReferenceText IncSearch
    hi default link LspReferenceText CursorLine
    hi default link LspReferenceRead LspReferenceText
    hi default link LspReferenceWrite LspReferenceText
    autocmd CursorHold  <buffer> lua vim.lsp.buf.document_highlight()
    autocmd CursorHoldI <buffer> lua vim.lsp.buf.document_highlight()
    autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
    ]])
end

local util = require('lspconfig/util')

local path = util.path

local function get_python_path(workspace)
    -- Use activated virtualenv.
    if vim.env.VIRTUAL_ENV then
        return path.join(vim.env.VIRTUAL_ENV, 'bin', 'python')
    end

    -- Find and use virtualenv via poetry in workspace directory.
    local match = vim.fn.glob(path.join(workspace, 'poetry.lock'))
    if match ~= '' then
        local venv = vim.fn.trim(vim.fn.system('poetry env info -p'))
        return path.join(venv, 'bin', 'python')
    end

    -- Find and use virtualenv in workspace directory.
    for _, pattern in ipairs({ '*', '.*' }) do
        local match = vim.fn.glob(path.join(workspace, pattern, 'pyvenv.cfg'))
        if match ~= '' then
            return path.join(path.dirname(match), 'bin', 'python')
        end
    end

    -- Fallback to system Python.
    return exepath('python3') or exepath('python') or 'python'
end

require('lspconfig')['pyright'].setup {
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
        formatting = {
            provider = "black"
        },
        linting = {
            mypyEnabled = true,
            pylintEnabled = true
        }
    },
    before_init = function(_, config)
        config.settings.python.pythonPath = get_python_path(config.root_dir)
    end
}
require('lspconfig')['tsserver'].setup {
    on_attach = on_attach,
    capabilities = capabilities,
}
require('lspconfig')['sumneko_lua'].setup {
    on_attach = on_attach,
    capabilities = capabilities,
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
    capabilities = capabilities,
    settings = {
        ["rust-analyzer"] = {}
    }
}