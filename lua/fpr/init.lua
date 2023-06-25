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

require("catppuccin").setup({
    color_overrides = {
        mocha = {
            base = "#000000",
            mantle = "#000000",
            crust = "#000000",

            text = "#dddddd",

            overlay0 = "#4a4a4a",
            overlay1 = "#939393",
            overlay2 = "#dddddd",

            surface0 = "#4a4a4a",
            surface1 = "#4a4a4a",
            surface2 = "#4a4a4a",

            pink = "#f2abb5",
            mauve = "#9298ed",
            green = "#3da94b",
            teal = "#1d5224",
            yellow = "#f8e8a0",
            peach = "#037603",
        },
    },
})

vim.cmd.colorscheme "catppuccin"

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
