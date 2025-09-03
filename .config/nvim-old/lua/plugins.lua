local on_attach = function(_, bufnr)
    local opts = { noremap = true, silent = true }
    local map = function(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
    map("n", "<leader>[", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
    map("n", "<leader>]", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
    map("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
    map("n", "gk", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
    map("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
end

return {
    -- only highlight search matches when searching
    {
        "romainl/vim-cool",
        keys = {"/", "*", "#", ":%"},
    },

    {
        "pocco81/auto-save.nvim",
        execution_message = {message = "AutoSave: saved at %H:%M:%S", dim = 0.18, cleaning_interval = 2000, },
        events = { "InsertLeave", "TextChanged" },
        conditions = {exists = true, filename_is_not = {}, filetype_is_not = { "gitcommit", "markdown" }, },
        write_all_buffers = false,
    },

    {
        'nvim-telescope/telescope.nvim',
        dependencies = {
            'nvim-lua/plenary.nvim',
	        {
                "nvim-telescope/telescope-fzf-native.nvim",
                build = "make",
                config = function() require("telescope").load_extension("fzf") end
            },
        },
	    keys = {
            "<C-p>",
            "<leader>;",
            "<leader>gg>",
            "<leader>G",
            "<leader>H",
            "<leader>q",
            "<leader>p",
        },
	    config = function()
            local actions = require("telescope.actions")
            require("telescope").setup {
                defaults = {
                    mappings = {
                        i = {
                            ["<C-j>"] = actions.move_selection_next,
                            ["<C-k>"] = actions.move_selection_previous,
                            ["<C-u>"] = actions.delete_buffer,
                            ["<esc>"] = actions.close,
                            ["kj"] = actions.close,
                        }
                    },
                },
            }
            local map = vim.api.nvim_set_keymap
            map('n', '<C-p>', '<CMD>lua require"telescope-config".project_files()<CR>', { noremap = true, silent = true })
            map("n", "<leader>H", "<cmd>Telescope help_tags<cr>", {})
            map("n", "<leader>;", "<cmd>Telescope commands<cr>", {})
            map("n", "<leader>p", "<cmd>Telescope tags<cr>", {})
            map("n", "<leader>gg", "<cmd>Telescope live_grep<cr>", { noremap = true, silent = true })
            map("n", "<leader>G", "<cmd>Telescope grep_string<cr>", {})
        end
    },

    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            require("nvim-treesitter.configs").setup {
                ensure_installed = {
                    "c",
                    "cpp",
                    "java",
                    "json",
                    "lua",
                    "make",
                    "python",
                    "rust",
                    "haskell",
                    "yaml",
                },
                highlight = { enable = true },
                matchup = {
                    enable = true,              -- mandatory, false will disable the whole extension
                    -- disable = { "c", "ruby" },  -- optional, list of language that will be disabled
                },
            }
            vim.cmd [[ highlight link pythonTSKeywordOperator Keyword ]]
        end
    },

    { "mfussenegger/nvim-jdtls" },

    {
        "neovim/nvim-lspconfig",
        ft = {"python", "c", "cpp", "lua", "go", "haskell", "rust" },
        dependencies = {
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
        },
        config = function ()
            local mason = require("mason")
            local mason_lspconfig = require("mason-lspconfig")
            mason.setup()
            mason_lspconfig.setup {
                ensure_installed = {
                    "pylsp",
                    "clangd",
                    "lua_ls",
                    "rust_analyzer",
                },
            }

            local lspconfig = require("lspconfig")
            vim.diagnostic.config { signs = false, update_in_insert = false }

            local map = vim.api.nvim_set_keymap
            map("n", "<leader>e", "<cmd>lua vim.diagnostic.open_float()<CR>", {})

            lspconfig.pylsp.setup {
                on_attach = on_attach,
            }
            lspconfig.clangd.setup {
                on_attach = on_attach
            }
            lspconfig.lua_ls.setup {
                on_attach = on_attach
            }
            lspconfig.rust_analyzer.setup {
                on_attach = on_attach,
                settings = {
                  ["rust-analyzer"] = {
                    completion = { autoimport = { enable = false } },
                  },
              },
            }
        end,
    },

    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        opts = {},
    },


    {
        "FooSoft/vim-argwrap",
        keys = { "<leader>w" },
        config = function()
            local augroup = vim.api.nvim_create_augroup("cacharle_vim_argwrap_group", {})
            vim.g.argwrap_tail_comma = 1
            vim.api.nvim_set_keymap("n", "<leader>w", "<cmd>ArgWrap<cr>", {})
            vim.api.nvim_create_autocmd(
                "Filetype",
                {
                    pattern = "c,cpp",
                    callback = function() vim.g.argwrap_tail_comma = 0 end,
                    group = augroup,
                }
            )
            vim.api.nvim_create_autocmd(
                "Filetype",
                {
                    pattern = "go,lua",
                    callback = function() vim.g.argwrap_padded_braces = "{" end,
                    group = augroup,
                }
            )
        end
    },

    "rktjmp/lush.nvim",

    {
        'kartikp10/noctis.nvim',
        requires = { 'rktjmp/lush.nvim' },
        config = function ()
           vim.cmd [[ colorscheme noctis ]]
        end
    },

     -- status line
    {
        "nvim-lualine/lualine.nvim",
        dependencies = {"kyazdani42/nvim-web-devicons"},
        config =  {
            options = {
                -- theme = "nord",
	        	icons_enabled = false;
                section_separators = '',
                component_separators = '',
            },
            sections = {
                lualine_a = { { "mode", fmt = function (s) return s:sub(1, 1) end } },
                -- path=1 for Relative path (https://github.com/nvim-lualine/lualine.nvim?tab=readme-ov-file#filename-component-options)
                lualine_c = { { "filename", path = 1 } },
            },
        },
    },

    {
        "RaafatTurki/hex.nvim",
        config = {}
    },

    {
       "goolord/alpha-nvim",
       dependencies = { 'nvim-tree/nvim-web-devicons' },
       config = function()
           local startify = require("alpha.themes.startify")
           startify.file_icons.provider = "devicons"
           require("alpha").setup(startify.config)
       end,
    },

    {
        "hrsh7th/nvim-cmp",
        event = "InsertEnter",
        enable = false,
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-nvim-lsp-signature-help",
            "onsails/lspkind.nvim",
            "L3MON4D3/LuaSnip",
        },
        config = function()
            local lspkind = require("lspkind")
            local cmp = require("cmp")
            local luasnip = require("luasnip")
            cmp.setup {
                mapping = cmp.mapping.preset.insert({
                    ["<C-n>"] = cmp.mapping.select_next_item(),
                    ["<C-p>"] = cmp.mapping.select_prev_item(),
                    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-f>"] = cmp.mapping.scroll_docs(4),
                    ["<Tab>"] = cmp.mapping.confirm({ select = true }),
                    ["<C-n>"] = cmp.mapping(function(fallback)
                        local has_words_before = function()
                          unpack = unpack or table.unpack
                          local line, col = unpack(vim.api.nvim_win_get_cursor(0))
                          return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
                        end
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
                    ["<C-p>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        elseif luasnip.jumpable(-1) then
                            luasnip.jump(-1)
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                }),
                -- order of the sources matter (first are higher priority)
                sources = {
                    { name = "luasnip" },
                    { name = "nvim_lsp" },
                    { name = "nvim_lsp_signature_help" },
                    { name = "path" },
                    { name = "buffer", keyword_length = 2 },
                },
                formatting = {
                    format = lspkind.cmp_format({
                        with_text = true,
                        mode = "text",
                        menu = {
                            nvim_lsp = "[LSP]",
                            path = "[path]",
                            buffer = "[buf]",
                        }
                    })
                },
                window = { documentation = cmp.config.window.bordered(), },
                experimental = { ghost_text = true, },
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end
                },
                entry_filter = function(entry, ctx)
                    -- only filter for Rust files (optional; drop for all if you like)
                    if ctx.ft == "rust" then
                        -- `additionalTextEdits` is exactly where RA tucks in the `use …` import
                        return not entry.completion_item.additionalTextEdits
                    end
                    return true
                end,
            }
        end,
    },
}
