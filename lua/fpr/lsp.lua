local lsp = require('lsp-zero')

lsp.preset("recommended")

-- (Optional) Configure lua language server for neovim
require('lspconfig').lua_ls.setup(lsp.nvim_lua_ls())

lsp.setup()
