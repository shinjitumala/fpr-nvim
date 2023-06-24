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

m("n", [[<A-x>]], "<Cmd>ToggleTerm<CR>", opts)
m("n", [[<C-k>x]], "<Cmd>TermSelect<CR>", opts)

m("n", [[<C-k>l]], "<Cmd>winc l<CR>", opts)
m("n", [[<C-k>h]], "<Cmd>winc h<CR>", opts)
m("n", [[<C-k>k]], "<Cmd>winc k<CR>", opts)
m("n", [[<C-k>j]], "<Cmd>winc j<CR>", opts)
m("n", [[<C-k><S-l>]], "<Cmd>winc L<CR>", opts)
m("n", [[<C-k><S-h>]], "<Cmd>winc H<CR>", opts)
m("n", [[<C-k><S-k>]], "<Cmd>winc K<CR>", opts)
m("n", [[<C-k><S-j>]], "<Cmd>winc J<CR>", opts)

local lsp = require("lsp-zero")
local cmp = require("cmp")
local cmp_s = { behavior = cmp.SelectBehavior.Select }

local cmpm = lsp.defaults.cmp_mappings({
    ["<A-k>"] = cmp.mapping.select_prev_item(cmp_s),
    ["<A-j>"] = cmp.mapping.select_next_item(cmp_s),
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
    ["<A-p>"] = cmp.mapping.scroll_docs(-4),
    ["<A-n>"] = cmp.mapping.scroll_docs(4),
    ["<A-I>"] = cmp.mapping.complete(),
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

m("t", [[<C-k>l]], "<Cmd>winc l<CR>", {})
m("t", [[<C-k>h]], "<Cmd>winc h<CR>", {})
m("t", [[<C-k>k]], "<Cmd>winc k<CR>", {})
m("t", [[<C-k>j]], "<Cmd>winc j<CR>", {})

require("nvim-tree").setup({
    on_attach = function(bufnr)
        local api = require("nvim-tree.api")
        local function opts(desc)
            return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
        end
        vim.keymap.set("n", "o", api.node.open.edit, opts("Open"))
        vim.keymap.set("n", "<2-LeftMouse>", api.node.open.edit, opts("Open"))
        vim.keymap.set("n", "d", api.fs.remove, opts("Delete"))

        vim.keymap.set("n", "R", api.tree.reload, opts("Reload"))

        vim.keymap.set("n", "/", api.tree.search_node, opts("Search"))

        vim.keymap.set("n", "c", api.fs.copy.relative_path, opts("Copy relative path"))
        vim.keymap.set("n", "C", api.fs.copy.absolute_path, opts("Copy absoulte path"))

        vim.keymap.set("n", "y", api.fs.copy.node, opts("Copy"))
        vim.keymap.set("n", "p", api.fs.paste, opts("Paste"))
        vim.keymap.set("n", "r", api.fs.rename, opts("Rename"))
        vim.keymap.set("n", "?", api.tree.toggle_help, opts("Toggle Help"))
    end
})

m("n", "<C-k>e", "<Cmd>NvimTreeFocus<CR>", opts)
m("n", "<A-e>", "<Cmd>NvimTreeToggle<CR>", opts)
