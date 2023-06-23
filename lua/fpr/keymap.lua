local m = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true, }

m('n', '<C-w>', '<Cmd>BufferClose<CR>', opts)

m('n', '<A-1>', '<Cmd>BufferGoto 1<CR>', opts)
m('n', '<A-2>', '<Cmd>BufferGoto 2<CR>', opts)
m('n', '<A-3>', '<Cmd>BufferGoto 3<CR>', opts)
m('n', '<A-4>', '<Cmd>BufferGoto 4<CR>', opts)
m('n', '<A-5>', '<Cmd>BufferGoto 5<CR>', opts)
m('n', '<A-6>', '<Cmd>BufferGoto 6<CR>', opts)
m('n', '<A-7>', '<Cmd>BufferGoto 7<CR>', opts)
m('n', '<A-8>', '<Cmd>BufferGoto 8<CR>', opts)
m('n', '<A-9>', '<Cmd>BufferGoto 9<CR>', opts)

m('n', 'gt', '<Cmd>BufferNext<CR>', opts)
m('n', 'gT', '<Cmd>BufferPrevious<CR>', opts)

m('n', [[<C-l><S-W>]], '<Cmd>BufferCloseAllButCurrent<CR>', opts) 
