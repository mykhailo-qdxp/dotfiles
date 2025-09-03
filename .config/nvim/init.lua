vim.o.number = true
vim.o.relativenumber = true
vim.o.signcolumn = "yes"
vim.o.wrap = false
vim.o.expandtab = true
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.swapfile = false
vim.g.mapleader = " "
vim.o.winborder = "rounded"

local map = vim.keymap
map.set('n', '<leader>o', ':update<CR> :source<CR>')
map.set('n', '<leader>w', ':write<CR>')
map.set('n', '<leader>q', ':quit<CR>')

map.set({'n', 'v', 'x'}, '<leader>y', '"+y<CR>')
map.set({'n', 'v', 'x'}, '<leader>d', '"+d<CR>')

vim.pack.add({
    { src = "https://github.com/vague2k/vague.nvim" },
    { src = "https://github.com/stevearc/oil.nvim" },
    { src = "https://github.com/neovim/nvim-lspconfig" },
    { src = "https://github.com/nvim-mini/mini.nvim" },
})

vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(ev)
        local client = vim.lsp.get_client_by_id(ev.data.client_id)
        if client:supports_method('textDocument/completition') then
            vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
        end
    end,
})
vim.cmd("set completeopt+=noselect")

require "mini.pick".setup()
require "oil".setup()

map.set('n', '<leader>f', ":Pick files<CR>")
map.set('n', '<leader>h', ":Pick help<CR>")
map.set('n', '<leader>e', ":Oil<CR>")

vim.lsp.enable({"pylsp", "clangd", "lua_ls", "rust_analyzer"})
map.set('n', '<leader>lf', vim.lsp.buf.format)

vim.cmd("colorscheme vague")
