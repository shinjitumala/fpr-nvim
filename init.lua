local env = require("env")

--<< Load plugins
vim.cmd [[packadd packer.nvim]]

require('packer').startup(function(use)
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'

    -- These optional plugins should be loaded directly because of a bug in Packer lazy loading
    use 'nvim-tree/nvim-web-devicons' -- OPTIONAL: for file icons
    use 'lewis6991/gitsigns.nvim'     -- OPTIONAL: for git status
    use 'romgrk/barbar.nvim'

    -- LSP Zero
    use {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v2.x',
        requires = {
            -- LSP Support
            { 'neovim/nvim-lspconfig' }, -- Required
            {                            -- Optional
                'williamboman/mason.nvim',
                run = function()
                    pcall(vim.cmd, 'MasonUpdate')
                end,
            },
            { 'williamboman/mason-lspconfig.nvim' }, -- Optional

            -- Autocompletion
            {
                'hrsh7th/nvim-cmp',
                'hrsh7th/cmp-buffer',
                'hrsh7th/cmp-path',
                -- config = function()
                -- require 'cmp'.setup {
                -- snippet = {
                --     expand = function(args)
                --         require 'luasnip'.lsp_expand(args.body)
                --     end
                -- },
                --
                -- sources = {
                --     { name = 'luasnip' },
                --     { name = 'nvim_lsp' },
                --     { name = "buffer", keyword_length = 3},
                --     -- more sources
                -- },
                -- }
                -- end
            },                          -- Required
            { 'hrsh7th/cmp-nvim-lsp' }, -- Required
            { 'L3MON4D3/LuaSnip' },     -- Required
        }
    }

    use { 'saadparwaiz1/cmp_luasnip' }

    use {
        'nvim-tree/nvim-tree.lua',
        requires = {
            'nvim-tree/nvim-web-devicons', -- optional
        },
    }

    use { "catppuccin/nvim", as = "catppuccin" }

    use 'tpope/vim-fugitive'

    use { 'numToStr/Comment.nvim', }

    use {
        'nvim-treesitter/nvim-treesitter',
        run = function()
            local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
            ts_update()
        end,
    }
    use {
        'nvim-telescope/telescope.nvim', tag = '0.1.2',
        -- or                            , branch = '0.1.x',
        requires = { { 'nvim-lua/plenary.nvim' } }
    }

    use { 'airblade/vim-gitgutter' }
end)
-->> Load plugins

local lsp = require('lsp-zero').preset("recommended")

-- (Optional) Configure lua language server for neovim
require('lspconfig').lua_ls.setup(lsp.nvim_lua_ls())

local cmp = require("cmp")
local cmp_s = { behavior = cmp.SelectBehavior.Select }

local cmpm = lsp.defaults.cmp_mappings({
    ["<A-k>"] = cmp.mapping.select_prev_item(cmp_s),
    ["<A-j>"] = cmp.mapping.select_next_item(cmp_s),
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
    ["<A-p>"] = cmp.mapping.scroll_docs(-4),
    ["<A-n>"] = cmp.mapping.scroll_docs(4),
    ["<A-i>"] = cmp.mapping.complete(),
})

lsp.on_attach(function(client, bufnr)
    local opts = { buffer = bufnr }
    local m = vim.keymap.set

    m("n", "<C-k>r", "<cmd>lua vim.lsp.buf.rename()<cr>", opts)
    m("n", "<C-k>m", "<cmd>lua vim.lsp.buf.format()<cr>", opts)
    m("n", "<S-K>", "<cmd>lua vim.lsp.buf.hover()<cr>", opts)
    m("n", "<C-K>.", "<cmd>lua vim.lsp.buf.code_action()<cr>", opts)

    m("n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>", opts)
    m("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", opts)
    m("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<cr>", opts)
    m("n", "gI", "<cmd>lua vim.lsp.buf.type_definition()<cr>", opts)
    m("n", "gr", "<cmd>lua vim.lsp.buf.references()<cr>", opts)
    m("n", "gs", "<cmd>lua vim.lsp.buf.signature_help()<cr>", opts)
    m("n", "gl", "<cmd>lua vim.diagnostic.open_float()<cr>", opts)
end)

lsp.setup()

cmp.setup({
    mapping = cmpm,
    sources = {
        { name = 'luasnip' },
        { name = 'nvim_lsp' },
        { name = "buffer",  keyword_length = 3 },
    },
})

local o = vim.opt
local tw = 4

o.tabstop = tw
o.shiftwidth = tw
o.softtabstop = tw
o.expandtab = true
o.smartindent = true

o.wrap = false

o.hlsearch = true
o.incsearch = true

o.clipboard = "unnamedplus"

o.scrolloff = 8
o.updatetime = 16

o.clipboard = "unnamed"

o.wrap = true

vim.wo.number = true

require("luasnip.loaders.from_vscode").lazy_load({ paths = env.snippets_dir })

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

            overlay0 = "#999999",
            overlay1 = "#aaaaaa",
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

if vim.fn.has("wsl") == 1 then
    vim.g.clipboard = {
        name = "wsl clipboard",
        copy = {
            ["+"] = env.w32yank_exe .. " -i --crlf",
            ["*"] = env.w32yank_exe .. " -i --crlf",
        },
        paste = {
            ["+"] = env.w32yank_exe .. " -o --lf",
            ["*"] = env.w32yank_exe .. " -o --lf",
        },
        cache_enabled = 1,
    }
else
end

require("nvim-treesitter.configs").setup({
    ensure_installed = {
        "bash",
        "awk",
        "c",
        "css",
        "csv",
        "cpp",
        "make",
        "ninja",
        "sql",
        "typescript",
        "json",
        "lua",
        "xml",
        "toml",
        "latex",
        "markdown_inline",
        "markdown",
        "html",
        "css",
        "yaml",
        "toml",
        "python",

    },
    highlight = {
        enable = true
    }
})

--<< Keymaps
local m = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true, }

m("n", "<C-w>", "<Cmd>BufferClose<CR>", opts)
m("n", "<C-k>y", "<Cmd>%y+<CR>", opts)

m("n", "<A-1>", "<Cmd>BufferGoto 1<CR>", opts)
m("n", "<A-2>", "<Cmd>BufferGoto 2<CR>", opts)
m("n", "<A-3>", "<Cmd>BufferGoto 3<CR>", opts)
m("n", "<A-4>", "<Cmd>BufferGoto 4<CR>", opts)
m("n", "<A-5>", "<Cmd>BufferGoto 5<CR>", opts)
m("n", "<A-6>", "<Cmd>BufferGoto 6<CR>", opts)
m("n", "<A-7>", "<Cmd>BufferGoto 7<CR>", opts)
m("n", "<A-8>", "<Cmd>BufferGoto 8<CR>", opts)
m("n", "<A-9>", "<Cmd>BufferGoto 9<CR>", opts)

m("n", "<C-k>1", "<Cmd>BufferGoto 1<CR>", opts)
m("n", "<C-k>2", "<Cmd>BufferGoto 2<CR>", opts)
m("n", "<C-k>3", "<Cmd>BufferGoto 3<CR>", opts)
m("n", "<C-k>4", "<Cmd>BufferGoto 4<CR>", opts)
m("n", "<C-k>5", "<Cmd>BufferGoto 5<CR>", opts)
m("n", "<C-k>6", "<Cmd>BufferGoto 6<CR>", opts)
m("n", "<C-k>7", "<Cmd>BufferGoto 7<CR>", opts)
m("n", "<C-k>8", "<Cmd>BufferGoto 8<CR>", opts)
m("n", "<C-k>9", "<Cmd>BufferGoto 9<CR>", opts)

m("n", "<C-k>g", "<Cmd>Gedit :<CR>", opts)

m("n", "gt", "<Cmd>BufferNext<CR>", opts)
m("n", "gT", "<Cmd>BufferPrevious<CR>", opts)

m("n", [[<C-k><S-W>]], "<Cmd>BufferCloseAllButCurrent<CR>", opts)

m("n", [[<C-k>l]], "<Cmd>winc l<CR>", opts)
m("n", [[<C-k>h]], "<Cmd>winc h<CR>", opts)
m("n", [[<C-k>k]], "<Cmd>winc k<CR>", opts)
m("n", [[<C-k>j]], "<Cmd>winc j<CR>", opts)
m("n", [[<C-k><S-l>]], "<Cmd>winc L<CR>", opts)
m("n", [[<C-k><S-h>]], "<Cmd>winc H<CR>", opts)
m("n", [[<C-k><S-k>]], "<Cmd>winc K<CR>", opts)
m("n", [[<C-k><S-j>]], "<Cmd>winc J<CR>", opts)

-- local lsp = require("lsp-zero")

m("t", [[<C-k>l]], "<Cmd>winc l<CR>", {})
m("t", [[<C-k>h]], "<Cmd>winc h<CR>", {})
m("t", [[<C-k>k]], "<Cmd>winc k<CR>", {})
m("t", [[<C-k>j]], "<Cmd>winc j<CR>", {})
m("t", "<C-k>e", "<Cmd>NvimTreeFocus<CR>", opts)

m("t", "<C-k>1", "<Cmd>NvimTreeFocus<CR><Cmd>BufferGoto 1<CR>", opts)
m("t", "<C-k>2", "<Cmd>NvimTreeFocus<CR><Cmd>BufferGoto 2<CR>", opts)
m("t", "<C-k>3", "<Cmd>NvimTreeFocus<CR><Cmd>BufferGoto 3<CR>", opts)
m("t", "<C-k>4", "<Cmd>NvimTreeFocus<CR><Cmd>BufferGoto 4<CR>", opts)
m("t", "<C-k>5", "<Cmd>NvimTreeFocus<CR><Cmd>BufferGoto 5<CR>", opts)
m("t", "<C-k>6", "<Cmd>NvimTreeFocus<CR><Cmd>BufferGoto 6<CR>", opts)
m("t", "<C-k>7", "<Cmd>NvimTreeFocus<CR><Cmd>BufferGoto 7<CR>", opts)
m("t", "<C-k>8", "<Cmd>NvimTreeFocus<CR><Cmd>BufferGoto 8<CR>", opts)
m("t", "<C-k>9", "<Cmd>NvimTreeFocus<CR><Cmd>BufferGoto 9<CR>", opts)

m("t", "<C-k>g", "<Cmd>NvimTreeFocus<CR><Cmd>Gedit :<CR>", opts)


m("n", "gq", "<cmd>nohl<cr>", opts)

require("nvim-tree").setup({
    on_attach = function(bufnr)
        local api = require("nvim-tree.api")
        local function opts(desc)
            return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
        end
        vim.keymap.set("n", "o", api.node.open.edit, opts("Open"))
        vim.keymap.set("n", "<CR>", api.node.open.edit, opts("Open"))
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

        vim.keymap.set("n", "gf", api.tree.toggle_gitignore_filter, opts("Toggle git ignore filter"))
        vim.keymap.set("n", "h", api.tree.toggle_hidden_filter, opts("Toggle hidden filter"))
        vim.keymap.set("n", "K", api.node.show_info_popup, opts("Show file info"))

        vim.keymap.set("n", "h", api.node.navigate.parent_close, opts("Navigate to parent"))

        vim.keymap.set("n", "a", api.fs.create, opts("Create file"))

        vim.keymap.set("n", "f", function()
                local n = api.tree.get_node_under_cursor()
                local dir = n.parent.absolute_path
                os.execute("cd \"" .. dir .. "\"; explorer.exe .")
            end,
            opts("Open in windows file explorer"))
    end
})

m("n", "<C-k>e", "<Cmd>NvimTreeFocus<CR>", opts)
m("n", "<A-e>", "<Cmd>NvimTreeToggle<CR>", opts)
m("n", "<Space>", "<Nop>", opts)

require('Comment').setup({
    toggler = {
        line = "cc",
        block = "cb",
    },
    opleader = {
        line = "cc",
        block = "cb",
    },
    mappings = {
        extra = false,
    },
})

m("n", "<C-k><S-s>", [[:lua os.execute("source ~/.bashrc; slack_quote")<CR>p]], opts)

local tele = require("telescope.builtin")

vim.keymap.set("n", "<C-k>F", tele.find_files, opts)
vim.keymap.set("n", "<C-k>ff", function()
    tele.live_grep({
        glob_pattern = { "*", "!.git" },
    })
end, opts)
vim.keymap.set("n", "<C-k>fa", function()
    tele.live_grep({
        glob_pattern = { "*.md", "!.git" },
    })
end, opts)
vim.keymap.set("n", "<C-k>fg", tele.live_grep, opts)

vim.keymap.set("n", "<C-k>c", '<cmd>let @+ = @%<CR>', opts)
vim.keymap.set("n", "<C-k>C", '<cmd>let @+ = expand("%:p")<CR>', opts)
-->> Keymaps
