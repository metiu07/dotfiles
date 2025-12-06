local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

local OPTS = { noremap = true, silent = true }

-- Printing values
-- print(vim.inspect(client))
-- print(client.get_language_id())
-- See the values in :messages

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local ON_ATTACH = function(client, bufnr)
    local map = vim.keymap.set
    local bufopts = { noremap = true, silent = true, buffer = bufnr }

    map("n", "gd", "<cmd>Lspsaga goto_definition<CR>")
    map("n", "gD", "<cmd>Lspsaga goto_type_definition<CR>")
    map('n', 'gi', vim.lsp.buf.implementation, bufopts)

    local builtin = require('telescope.builtin')
    map('n', 'gj', builtin.lsp_dynamic_workspace_symbols, bufopts)
    map('n', 'gJ', builtin.lsp_workspace_symbols, bufopts)

    map('n', 'gr', builtin.lsp_references, bufopts)

    map("n", "K", "<cmd>Lspsaga hover_doc<CR>")
    map('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)

    map({ "n", "v" }, "<leader>a", "<cmd>Lspsaga code_action<CR>")
    map("n", "<leader>r", "<cmd>Lspsaga rename<CR>")

    map("n", "<leader>sl", "<cmd>Lspsaga show_line_diagnostics<CR>")
    map("n", "<leader>sc", "<cmd>Lspsaga show_cursor_diagnostics<CR>")
    map("n", "<leader>sb", "<cmd>Lspsaga show_buf_diagnostics<CR>")

    map("n", "<leader>o", "<cmd>Lspsaga outline<CR>")
    map("n", "<Leader>ci", "<cmd>Lspsaga incoming_calls<CR>")
    map("n", "<Leader>co", "<cmd>Lspsaga outgoing_calls<CR>")
    map({ "n", "t" }, "<A-d>", "<cmd>Lspsaga term_toggle<CR>")

    map('n', '<leader>Wa', vim.lsp.buf.add_workspace_folder, bufopts)
    map('n', '<leader>Wr', vim.lsp.buf.remove_workspace_folder, bufopts)
    map('n', '<leader>Wl', function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, bufopts)

    map('n', '<leader>f', function()
        print("Formatting")
        require("conform").format({ async = true })
    end, bufopts)

    -- Automatic formatting on save
    vim.g.anon_format_on_save = false
    map('n', '<leader>F', function()
        if vim.g.anon_format_on_save then
            vim.g.anon_format_on_save = false
            vim.cmd("autocmd! BufWritePre <buffer>")
            print("Auto formatting on save disabled")
        else
            vim.cmd("autocmd BufWritePre <buffer> lua require('conform').format()")
            vim.g.anon_format_on_save = true
            print("Auto formatting on save enabled")
        end
    end, bufopts)

    map("n", "[e", "<cmd>Lspsaga diagnostic_jump_prev<CR>")
    map("n", "]e", "<cmd>Lspsaga diagnostic_jump_next<CR>")
    map("n", "[E", function()
        require("lspsaga.diagnostic"):goto_prev({ severity = vim.diagnostic.severity.ERROR })
    end)
    map("n", "]E", function()
        require("lspsaga.diagnostic"):goto_next({ severity = vim.diagnostic.severity.ERROR })
    end)

    -- TODO: Add a way to distinguish between read/write
    -- NOTE: Currently disabled because spamming errors in YAML files
    if client.name ~= "yamlls" then
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
end


vim.cmd('source ' .. vim.fn.expand('$HOME/.config/nvim/config.vim'))

require('lazy').setup({
    -- TODO: Consider https://github.com/ziontee113/syntax-tree-surfer
    -- TODO: Consider https://github.com/windwp/nvim-autopairs
    -- TODO: Consider https://github.com/Wansmer/treesj

    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        opts = {
            indent = { char = "|" },
            exclude = {
                filetypes = {
                    'markdown',
                    'org',
                    'lspinfo',
                    'packer',
                    'checkhealth',
                    'help',
                    'man',
                    'gitcommit',
                    'TelescopePrompt',
                    'TelescopeResults',
                },

            }
        }
    },

    'tpope/vim-abolish',
    'tpope/vim-commentary',
    'godlygeek/tabular',

    -- Telescope
    {
        'nvim-telescope/telescope.nvim',
        tag = 'v0.1.9',
        dependencies = { 'nvim-lua/plenary.nvim' },
        config = function()
            require('telescope').setup({
                defaults = {
                    layout_strategy = 'vertical',
                    layout_config = {
                        preview_cutoff = 1,
                    },
                    mappings = {
                        i = {
                            ["<C-n>"] = "move_selection_next",
                            ["<C-e>"] = "move_selection_previous",
                        }
                    },
                },
                pickers = {
                    find_files = {
                        hidden = true
                    },
                    buffers = {
                        ignore_current_buffer = true,
                        sort_mru = true
                    }
                },
                extensions = {
                    fzf = {
                        fuzzy = true,
                        override_generic_sorter = true,
                        override_file_sorter = true,
                        case_mode = "smart_case",
                    }
                }
            })
            local builtin = require('telescope.builtin')
            vim.keymap.set('n', '<leader><leader>', builtin.find_files, {})
            vim.keymap.set('n', '<leader>.', function() builtin.find_files({ no_ignore = true }) end, {})
            vim.keymap.set('n', '<leader>?', builtin.live_grep, {})
            vim.keymap.set('n', '<leader>/',
                function()
                    builtin.grep_string({ shorten_path = true, word_match = "-w", only_sort_text = true, search = '' })
                end,
                {})
            vim.keymap.set('n', '<leader>,', builtin.buffers, {})
            vim.keymap.set('n', '<leader>hh', builtin.help_tags, {})
            vim.keymap.set('n', '<leader>hk', builtin.keymaps, {})
            vim.keymap.set('n', '<leader>x', builtin.commands, {})
            vim.keymap.set('n', '<leader>R', builtin.registers, {})
            vim.keymap.set('n', 'z=', builtin.spell_suggest, {})

            require('telescope').load_extension('fzf')
        end,
    },
    { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },

    {
        'ethanholz/nvim-lastplace',
        opts = {
            lastplace_ignore_buftype = { "quickfix", "nofile", "help" },
            lastplace_ignore_filetype = { "gitcommit", "gitrebase", "svn", "hgcommit" },
        },
    },

    -- GIT
    -- TODO: Consider https://github.com/ahmedkhalf/project.nvim
    'airblade/vim-rooter',
    {
        'tpope/vim-fugitive',
        keys = {
            { "<leader>gg", "<cmd>Git<CR>",       desc = "Git status", },
            { "<leader>gb", "<cmd>Git blame<CR>", desc = "Git blame", },
        }
    },
    {
        'lewis6991/gitsigns.nvim',
        config = true,
    },
    {
        'folke/todo-comments.nvim',
        event = 'VimEnter',
        dependencies = { 'nvim-lua/plenary.nvim' },
        opts = { signs = true }
    },
    'sindrets/diffview.nvim',

    {
        'stevearc/oil.nvim',
        dependencies = { "nvim-tree/nvim-web-devicons" },
        opts = {},
        keys = {
            { "-", "<cmd>Oil<CR>", desc = "Open Oil FS editor.", },
        }
    },

    -- LSP
    {
        'neovim/nvim-lspconfig',
        config = function()
            local capabilities = require('cmp_nvim_lsp').default_capabilities()

            -- LSP
            vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, OPTS)
            vim.keymap.set('n', '[g', vim.diagnostic.goto_prev, OPTS)
            vim.keymap.set('n', ']g', vim.diagnostic.goto_next, OPTS)
            vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, OPTS)

            local util = require('lspconfig.util')

            local path = util.path

            local function get_python_path(workspace)
                -- Use activated virtualenv.
                if vim.env.VIRTUAL_ENV then
                    return path.join(vim.env.VIRTUAL_ENV, 'bin', 'python')
                end

                -- Find and use virtualenv via poetry in workspace directory.
                local match = vim.fn.glob(path.join(workspace, 'poetry.lock'))
                if match ~= '' then
                    local venv = vim.fn.trim(vim.fn.system('poetry env info -p 2>/dev/null'))
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
                return vim.fn.exepath('python3') or vim.fn.exepath('python') or 'python'
            end

            vim.lsp.config.pyright = {
                on_attach = ON_ATTACH,
                capabilities = capabilities,
                before_init = function(_, config)
                    if config.root_dir == nil then
                        return
                    end
                    config.settings.python.pythonPath = get_python_path(config.root_dir)
                end
            }
            vim.lsp.config.ruff = {
                on_attach = ON_ATTACH,
                capabilities = capabilities,
                before_init = function(_, config)
                    if config.root_dir == nil then
                        return
                    end
                    config.interpreter = get_python_path(config.root_dir)
                end
            }
            vim.lsp.config.ts_ls = {
                on_attach = ON_ATTACH,
                capabilities = capabilities,
            }
            vim.lsp.config.gopls = {
                on_attach = ON_ATTACH,
                capabilities = capabilities,
            }
            vim.lsp.config.bashls = {
                on_attach = ON_ATTACH,
                capabilities = capabilities,
            }
            -- require('lspconfig')['nixd'].setup {
            --     on_attach = ON_ATTACH,
            --     capabilities = capabilities,
            -- }
            vim.lsp.config.nil_ls = {
                on_attach = ON_ATTACH,
                capabilities = capabilities,
                settings = {
                    ['nil'] = {
                        formatting = {
                            command = { "nixpkgs-fmt" },
                        },
                    },
                }
            }
            vim.lsp.config.rust_analyzer = {
                on_attach = ON_ATTACH,
                capabilities = capabilities,
            }
            vim.lsp.config.yamlls = {
                on_attach = ON_ATTACH,
                capabilities = capabilities,
                settings = {
                    yaml = {
                        schemas = {
                            kubernetes = { "/luft/*/*.yaml", "/kubernetes/*/*.yaml" },
                            ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*"
                        }
                    }
                }
            }
            -- For some reason we need to set offsetEncoding to utf-8 for clangd to work
            local clangd_capabilities = require('cmp_nvim_lsp').default_capabilities()
            clangd_capabilities.offsetEncoding = "utf-8"
            vim.lsp.config.clangd = {
                on_attach = ON_ATTACH,
                capabilities = clangd_capabilities,
            }
            vim.lsp.config.lua_ls = {
                on_attach = ON_ATTACH,
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
            vim.lsp.config.yls = {
                on_attach = ON_ATTACH,
                capabilities = capabilities,
            }
        end,
    },
    {
        'stevearc/conform.nvim',
        opts = {
            formatters_by_ft = {
                python = { "ruff_fix", "ruff_organize_imports", "ruff_format" },
                html = { "prettier" },
                json = { "prettier" },
            },
            default_format_opts = {
                lsp_format = "fallback",
            },
        },
        init = function()
            vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
        end,
    },
    {
        'nvimdev/lspsaga.nvim',
        opts = {
            symbol_in_winbar = {
                enable = false,
            },
            finder = {
                default = "ref+imp",
                max_height = 1,
                left_width = 0.2,
                keys = {
                    quit = "<esc>",
                    toggle_or_open = "<cr>",
                }
            },
            lightbulb = {
                enable = false,
                enable_in_insert = false,
                sign = false,
                sign_priority = 40,
                virtual_text = false,
            },
        },
        dependencies = {
            'nvim-treesitter/nvim-treesitter',
            'nvim-tree/nvim-web-devicons',
        },
    },

    -- Completion
    -- 'honza/vim-snippets',
    'L3MON4D3/LuaSnip',
    'saadparwaiz1/cmp_luasnip',
    {
        'hrsh7th/nvim-cmp',
        dependencies = {
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-buffer',
            'hrsh7th/cmp-path',
            'hrsh7th/cmp-cmdline',
        },
        config = function()
            -- Completion
            vim.opt.completeopt = { 'menu', 'menuone', 'noselect' }

            -- Set up nvim-cmp.
            local has_words_before = function()
                local line, col = unpack(vim.api.nvim_win_get_cursor(0))
                return col ~= 0 and
                    vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
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
                    ['<C-Space>'] = cmp.mapping.complete(),
                    ['<C-e>'] = cmp.mapping.abort(),
                    ['<CR>'] = cmp.mapping.confirm({ select = false }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
                }),
                sources = cmp.config.sources({
                    { name = 'nvim_lsp' },
                    { name = 'luasnip' },
                }, {
                    { name = "path" },
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
        end,
    },
    'onsails/lspkind.nvim',

    {
        "github/copilot.vim",
        init = function()
            vim.cmd([[
                let g:copilot_filetypes = {
                      \ 'gitcommit': v:true,
                      \ 'yaml': v:true,
                      \ 'toml': v:true,
                      \ 'json': v:true,
                      \ 'markdown': v:false,
                      \ 'org': v:false,
                      \ }
                let g:copilot_no_tab_map = v:true
                imap <silent><script><expr> <C-F> copilot#Accept("")
            ]])
        end,
    },

    -- Syntax
    {
        "nvim-treesitter/nvim-treesitter",
        lazy = false,
        branch = "main",
        build = ":TSUpdate",
        config = function()
            require('nvim-treesitter').install({
                "bash",
                "c",
                "diff",
                "dockerfile",
                "fish",
                "javascript",
                "json",
                "lua",
                "markdown",
                "markdown_inline",
                "python",
                "rust",
                "typescript",
            })

            -- Automatically start treesitter for supported filetypes
            vim.api.nvim_create_autocmd('FileType', {
                callback = function(args)
                    local lang = vim.treesitter.language.get_lang(args.match) or args.match
                    local installed = require('nvim-treesitter').get_installed('parsers')

                    if vim.tbl_contains(installed, lang) then
                        vim.treesitter.start(args.buf)
                    end
                end,
            })
        end
    },
    {
        'nvim-treesitter/nvim-treesitter-textobjects',
        branch = 'main',
        lazy = false,
        dependencies = { 'nvim-treesitter/nvim-treesitter' },
        config = function()
            require('nvim-treesitter-textobjects').setup({
                select = {
                    lookahead = true,
                    include_surrounding_whitespace = true,
                },
            })

            -- Text object keymaps
            -- FUNCTION = af + if
            local select = require('nvim-treesitter-textobjects.select')
            vim.keymap.set({ "x", "o" }, "af", function()
                select.select_textobject("@function.outer", "textobjects")
            end, { desc = "Select function outer" })
            vim.keymap.set({ "x", "o" }, "if", function()
                select.select_textobject("@function.inner", "textobjects")
            end, { desc = "Select function inner" })
            -- CLASS = ac + ic
            vim.keymap.set({ "x", "o" }, "ac", function()
                select.select_textobject("@class.outer", "textobjects")
            end, { desc = "Select class outer" })
            vim.keymap.set({ "x", "o" }, "ic", function()
                select.select_textobject("@class.inner", "textobjects")
            end, { desc = "Select class inner" })
            -- PARAMETER = aa + ia
            vim.keymap.set({ "x", "o" }, "aa", function()
                select.select_textobject("@parameter.outer", "textobjects")
            end, { desc = "Select parameter outer" })
            vim.keymap.set({ "x", "o" }, "ia", function()
                select.select_textobject("@parameter.inner", "textobjects")
            end, { desc = "Select parameter inner" })

            -- Swap keymaps
            local swap = require('nvim-treesitter-textobjects.swap')
            vim.keymap.set("n", "<C-i>", function()
                swap.swap_next("@parameter.inner")
            end, { desc = "Swap parameter with next" })
            vim.keymap.set("n", "<C-n>", function()
                swap.swap_next("@function.outer")
            end, { desc = "Swap function with next" })
            vim.keymap.set("n", "<C-m>", function()
                swap.swap_previous("@parameter.inner")
            end, { desc = "Swap parameter with previous" })
            vim.keymap.set("n", "<C-e>", function()
                swap.swap_previous("@function.outer")
            end, { desc = "Swap function with previous" })
        end
    },
    { 's3rvac/vim-syntax-yara' },

    {
        'norcalli/nvim-colorizer.lua',
        config = function()
            require('colorizer').setup()
        end,
    },

    {
        'nvim-orgmode/orgmode',
        event = 'VeryLazy',
        ft = { 'org' },
        config = function()
            -- Setup orgmode
            require('orgmode').setup({
                org_agenda_files = '~/orgfiles/**/*',
                org_default_notes_file = '~/orgfiles/refile.org',
                org_adapt_indentation = false,
                org_startup_folded = 'showeverything',
                mappings = {
                    org = {
                        org_todo = '<CR>',
                    },
                },
            })

            -- Disable indentexpr for org files
            vim.api.nvim_create_autocmd('FileType', {
                pattern = 'org',
                callback = function()
                    vim.opt_local.indentexpr = ''
                end,
            })
        end,
        -- In the past I had to disable this plugin because it was crashing my neovim on MacOS
        enabled = true,
    },

    -- Color themes
    {
        'morhetz/gruvbox',
        enabled = false,
        lazy = false,
        priority = 1000,
        config = function()
            vim.o.background = "light"
            vim.cmd.colorscheme('gruvbox')
        end
    },
    {
        'ishan9299/modus-theme-vim',
        enabled = false,
        lazy = false,
        priority = 1000,
        config = function()
            vim.o.background = "light"
            vim.cmd.colorscheme('modus-operandi')

            -- Fix highlighting in gitcommit diff
            -- vim.cmd([[
            --     highlight! link @diff.plus.diff diffAdded
            --     highlight! link @diff.minus.diff diffRemoved
            -- ]])
        end
    },
    {
        'sainnhe/gruvbox-material',
        enabled = false,
        lazy = false,
        priority = 1000,
        config = function()
            vim.o.background = "light"
            vim.cmd.colorscheme('gruvbox-material')

            -- Fix highlighting in gitcommit diff
            vim.cmd([[
                highlight! link @diff.plus.diff diffAdded
                highlight! link @diff.minus.diff diffRemoved
            ]])
        end
    },
    {
        'luisiacc/gruvbox-baby',
        enabled = false,
        lazy = false,
        priority = 1000,
        config = function()
            vim.g.gruvbox_baby_use_original_palette = 1
            vim.cmd.colorscheme('gruvbox-baby')

            -- Fix highlighting in gitcommit diff
            vim.cmd([[
                highlight! link @text.diff.add diffAdded
                highlight! link @text.diff.delete diffRemoved
            ]])
        end
    },
    {
        "neanias/everforest-nvim",
        enabled = false,
        lazy = false,
        priority = 1000,
        config = function()
            vim.o.background = "light"
            require("everforest").load()
        end,
    },
    {
        'projekt0n/github-nvim-theme',
        enabled = false,
        lazy = false,
        priority = 1000,
        config = function()
            -- require('github-theme').setup()
            vim.o.background = "light"
            vim.cmd.colorscheme('github_light')
            require('lualine').setup()
        end,
    },
    {
        "folke/tokyonight.nvim",
        enabled = false,
        lazy = false,
        priority = 1000,
        opts = {},
        config = function()
            vim.o.background = "light"
            vim.cmd.colorscheme('tokyonight-day')
            require('lualine').setup()
        end,
    },
    {
        'maxmx03/solarized.nvim',
        enabled = true,
        lazy = false,
        priority = 1000,
        config = function()
            vim.o.termguicolors = true
            vim.o.background = 'light'
            -- Fix the strikethrough in SpellBad
            require('solarized').setup({
                on_highlights = function(colors, color)
                    ---@type solarized.highlights
                    local groups = {
                        SpellBad = { strikethrough = false },
                    }

                    return groups
                end
            })
            vim.cmd.colorscheme('solarized')
        end,
    },
    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
    },
})

-- Highlight yanked things
-- FIXME: Convert to lua
vim.cmd([[
augroup highlight_yank
    autocmd!
    au TextYankPost * silent! lua vim.highlight.on_yank{higroup="IncSearch", timeout=50}
augroup END
]])

vim.o.cursorline = true

-- Jump to a first task in the file
vim.keymap.set('n', '<leader>j',
    function()
        vim.fn.cursor(1, 1)
        if vim.bo.filetype == 'markdown' then
            vim.fn.search('- \\[ \\]')
        elseif vim.bo.filetype == 'org' then
            vim.fn.search('^\\*\\+ TODO')
        end
    end,
    { noremap = true, silent = true })
