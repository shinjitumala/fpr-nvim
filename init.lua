-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out,                            "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

-- Setup lazy.nvim
require("lazy").setup({
    spec = {
        { "lewis6991/gitsigns.nvim" },
        { "romgrk/barbar.nvim" },

        {
            "VonHeikemen/lsp-zero.nvim",
            branch = "v4.x",
            config = function()
                local lsp_attach = function(_, bufnr)
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

                    m("n", "<C-k>d", "<cmd>lua vim.diagnostic.goto_next()<cr>", opts)
                    m("n", "<C-k>D", "<cmd>lua vim.diagnostic.goto_prev()<cr>", opts)
                end
                require("lsp-zero").extend_lspconfig({
                    capabilities = require("cmp_nvim_lsp").default_capabilities(),
                    lsp_attach = lsp_attach,
                })
            end
        },
        { "neovim/nvim-lspconfig" },
        { "williamboman/mason.nvim", opts = {} },
        {
            "williamboman/mason-lspconfig.nvim",
            dependencies = { "VonHeikemen/lsp-zero.nvim" },
            opts = function()
                return {
                    ensure_installed = {
                    },
                    handlers = {
                        function(server_name)
                            require("lspconfig")[server_name].setup({})
                        end
                    }
                }
            end
        },
        {
            "hrsh7th/nvim-cmp",
            opts = function()
                local cmp = require("cmp")
                local cmp_s = { behavior = cmp.SelectBehavior.Select }
                return {
                    mapping = cmp.mapping.preset.insert({
                        ["<A-k>"] = cmp.mapping.select_prev_item(cmp_s),
                        ["<A-j>"] = cmp.mapping.select_next_item(cmp_s),
                        ["<CR>"] = cmp.mapping.confirm({ select = true }),
                        ["<A-p>"] = cmp.mapping.scroll_docs(-4),
                        ["<A-n>"] = cmp.mapping.scroll_docs(4),
                        ["<A-i>"] = cmp.mapping.complete(),
                    }),
                    sources = {
                        { name = 'luasnip' },
                        { name = 'nvim_lsp' },
                        { name = "buffer",  keyword_length = 3 },
                        per_filetype = {
                            codecompanion = { "codecompanion" },
                        },
                    },
                }
            end
        },
        { "hrsh7th/cmp-nvim-lsp" },
        { "L3MON4D3/LuaSnip" },

        {
            'nvim-tree/nvim-tree.lua',
            dependencies = {
                'nvim-tree/nvim-web-devicons',
            },
            opts = {
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
                            local n = api.tree.get_node_under_cursor().absolute_path
                            if vim.fn.has("wsl") == 1 then
                                os.execute("x=\"" ..
                                    n ..
                                    "\"; y=$(dirname \"$x\"); z=$(basename \"$x\"); cd \"$y\" && explorer.exe \"$z\" &> /dev/null")
                            else
                                os.execute("pcmanfm \"" .. n .. "\" &> /dev/null")
                            end
                        end,
                        opts("Open in windows file explorer"))
                end
            }
        },
        { "nvim-tree/nvim-web-devicons",   opts = {} },

        {
            "catppuccin/nvim",
            name = "catppuccin",
            opts = function()
                vim.api.nvim_set_hl(0, "@markup.raw.block.markdown", { link = "Text" })
                vim.api.nvim_set_hl(0, "@markup.raw.markdown_inline", { link = "Text" })
                return {
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
                }
            end,
            init = function()
                vim.cmd.colorscheme "catppuccin"
            end
        },

        {
            "numToStr/Comment.nvim",
            opts = {
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
            }
        },
        { "nvim-telescope/telescope.nvim", dependencies = { "nvim-lua/plenary.nvim" } },
        { 'airblade/vim-gitgutter' },
        { 'tpope/vim-fugitive' },

        {
            'saadparwaiz1/cmp_luasnip',
        },

        -- LLM
        {
            "olimorris/codecompanion.nvim",
            opts = {},
            dependencies = {
                "nvim-lua/plenary.nvim",
                "nvim-treesitter/nvim-treesitter",
            },
        },
        {
            "OXY2DEV/markview.nvim",
            lazy = true,
            opts = {
                preview = {
                    filetypes = { "markdown", "codecompanion" },
                    ignore_buftypes = {},
                },
            },
        },
        {
            "echasnovski/mini.diff",
            config = function()
                local diff = require("mini.diff")
                diff.setup({
                    -- Disabled by default
                    source = diff.gen_source.none(),
                })
            end,
        },
        {
            "HakonHarnes/img-clip.nvim",
            opts = {
                filetypes = {
                    codecompanion = {
                        prompt_for_file_name = false,
                        template = "[Image]($FILE_PATH)",
                        use_absolute_path = true,
                    },
                },
            },
        },
        -- Moved for markview
        {
            'nvim-treesitter/nvim-treesitter',
            build = ":TSUpdate",
            main = "nvim-treesitter.configs",
            opts = {
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
            }
        },
    },
})

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

local o = vim.opt
local tw = 4

o.tabstop = tw
o.shiftwidth = tw
o.softtabstop = tw
o.expandtab = true
o.smartindent = true
o.relativenumber = true

o.wrap = false

o.hlsearch = true
o.incsearch = true

o.clipboard = "unnamedplus"

o.scrolloff = 8
o.updatetime = 16

o.wrap = true

vim.wo.number = true
vim.opt.signcolumn = 'yes'
vim.opt.termguicolors = true

local hasenv, env = pcall(require, "env")
if not hasenv then
    env = {}
end

require("luasnip.loaders.from_vscode").lazy_load({ paths = env.snippets_dir })

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

-- Keymaps
local m = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true, }

m("n", "<C-k>w", "<Cmd>BufferClose<CR>", opts)
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

local lsp = require("lspconfig")
lsp.denols.setup({
    root_dir = lsp.util.root_pattern("deno.json"),
})

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

m("n", "<C-k>e", "<Cmd>NvimTreeFocus<CR>", opts)
m("n", "<A-e>", "<Cmd>NvimTreeToggle<CR>", opts)
m("n", "<Space>", "<Nop>", opts)

local tele = require("telescope.builtin")

m("n", "<C-k><S-s>", [[:lua os.execute("source ~/.bashrc; slack_quote")<CR>p]], opts)

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

if not hasenv then
    require("codecompanion").setup({
        adapters = {
            llama = function()
                return require("codecompanion.adapters").extend("openai_compatible", {
                    env = {
                        url = "http://fpr1.local:11434",
                        chat_url = "/v1/chat/completions", -- Standard OpenAI chat endpoint
                        models_endpoint = "/v1/models",    -- Endpoint to retrieve available models
                    },
                    schema = {
                        model = {
                            default = "your-model-name", -- Replace with your loaded model name
                        },
                        temperature = {
                            order = 2,
                            mapping = "parameters",
                            type = "number",
                            optional = true,
                            default = 0.7,
                            desc = "What sampling temperature to use, between 0 and 2.",
                            validate = function(n)
                                return n >= 0 and n <= 2, "Must be between 0 and 2"
                            end,
                        },
                        max_tokens = {
                            order = 3,
                            mapping = "parameters",
                            type = "integer",
                            optional = true,
                            default = 2048,
                            desc = "Maximum number of tokens to generate.",
                            validate = function(n)
                                return n > 0, "Must be greater than 0"
                            end,
                        },
                        top_p = {
                            order = 4,
                            mapping = "parameters",
                            type = "number",
                            optional = true,
                            default = 0.9,
                            desc = "Nucleus sampling parameter.",
                            validate = function(n)
                                return n >= 0 and n <= 1, "Must be between 0 and 1"
                            end,
                        },
                        repeat_penalty = {
                            order = 5,
                            mapping = "parameters",
                            type = "number",
                            optional = true,
                            default = 1.1,
                            desc = "Penalty for repetition.",
                            validate = function(n)
                                return n >= 0, "Must be non-negative"
                            end,
                        },
                        stop = {
                            order = 6,
                            mapping = "parameters",
                            type = "table",
                            optional = true,
                            default = nil,
                            desc = "Stop sequences for generation.",
                        },
                    }
                })
            end
        },
        strategies = {
            chat = {
                adapter = "llama",
            },
            inline = {
                adapter = "llama",
            },
            cmd = {
                adapter = "llama",
            },
        },
    })
end
