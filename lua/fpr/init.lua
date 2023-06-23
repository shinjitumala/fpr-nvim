require("fpr.packer")
require("fpr.keymap")

local o = vim.o
local tw = 4
o.tabstop = tw
o.shiftwidth = tw
o.softtabstop = tw
o.expandtab = true

vim.wo.number = true
