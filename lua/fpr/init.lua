require("fpr.packer")
require("fpr.keymap")
require("fpr.lsp")

local o = vim.opt
local tw = 4

o.tabstop = tw
o.shiftwidth = tw
o.softtabstop = tw
o.expandtab = true
o.smartindent = true

o.wrap = false

o.hlsearch = false
o.incsearch = true

o.clipboard = "unnamedplus"

o.scrolloff = 8
o.updatetime = 16

vim.wo.number = true

require("autoclose").setup({})

require("luasnip.loaders.from_snipmate").lazy_load {
    paths = vim.fn.stdpath "config" .. "/snippet"
}

require("toggleterm").setup {
    hide_numbers = true,
    winbar = {
        enabled = false,
    },
}

-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- set termguicolors to enable highlight groups
vim.opt.termguicolors = true

-- if vim.fn.has("wsl") == 1 then
--     print("WSL")
-- else
--     vim.g.clipboard = {
--         name = "wsl clipboard",
--         copy = {
--             ["+"] = { "xcilp -selection c" },
--             ["*"] = { "xcilp -selection c" },
--         },
--         paste = {
--             ["+"] = { "xcilp -selection c -o" },
--             ["*"] = { "xcilp -selection c -o" },
--         },
--         cache_enabled = 1,
--     }
--     print("HELLO LINUX")
-- end
