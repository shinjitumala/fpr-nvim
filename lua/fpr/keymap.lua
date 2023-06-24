local m = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true, }

m("n", "<C-w>", "<Cmd>BufferClose<CR>", opts)

m("n", "<A-1>", "<Cmd>BufferGoto 1<CR>", opts)
m("n", "<A-2>", "<Cmd>BufferGoto 2<CR>", opts)
m("n", "<A-3>", "<Cmd>BufferGoto 3<CR>", opts)
m("n", "<A-4>", "<Cmd>BufferGoto 4<CR>", opts)
m("n", "<A-5>", "<Cmd>BufferGoto 5<CR>", opts)
m("n", "<A-6>", "<Cmd>BufferGoto 6<CR>", opts)
m("n", "<A-7>", "<Cmd>BufferGoto 7<CR>", opts)
m("n", "<A-8>", "<Cmd>BufferGoto 8<CR>", opts)
m("n", "<A-9>", "<Cmd>BufferGoto 9<CR>", opts)

m("n", "gt", "<Cmd>BufferNext<CR>", opts)
m("n", "gT", "<Cmd>BufferPrevious<CR>", opts)

m("n", [[<C-k><S-W>]], "<Cmd>BufferCloseAllButCurrent<CR>", opts) 

m("n", [[<C-k>x]], "<Cmd>ToggleTerm<CR>", opts) 

local lsp = require("lsp-zero")
local cmp = require("cmp")
local cmp_s = { behavior = cmp.SelectBehavior.Select }

local cmpm = lsp.defaults.cmp_mappings({
    ["<A-k>"] = cmp.mapping.select_prev_item(cmp_s),
    ["<A-j>"] = cmp.mapping.select_next_item(cmp_s),
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
    ["<A-p>"] = cmp.mapping.scroll_docs(-4),
    ["<A-n>"] = cmp.mapping.scroll_docs(4),
    ["<S-C>"] = cmp.mapping.complete(),
})

lsp.on_attach(function(client, bufnr)
    local opts = { buffer = bufnr }
    local m = vim.keymap.set

    m("n", "<C-k>r", "<cmd>lua vim.lsp.buf.rename()<cr>", opts)
    m("n", "<C-k>f", "<cmd>lua vim.lsp.buf.format()<cr>", opts)
    m("n", "<S-K>", "<cmd>lua vim.lsp.buf.hover()<cr>", opts)
    m("n", "<C-K>c", "<cmd>lua vim.lsp.buf.code_action()<cr>", opts)

    m("n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>", opts)
    m("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", opts)
    m("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<cr>", opts)
    m("n", "gt", "<cmd>lua vim.lsp.buf.type_definition()<cr>", opts)
    m("n", "gr", "<cmd>lua vim.lsp.buf.references()<cr>", opts)
    m("n", "gs", "<cmd>lua vim.lsp.buf.signature_help()<cr>", opts)
    m("n", "gl", "<cmd>lua vim.diagnostic.open_float()<cr>", opts)
end)

lsp.setup_nvim_cmp({
    mapping = cmpm
})
