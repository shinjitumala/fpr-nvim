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
        {
            "nvim-telescope/telescope.nvim",
            dependencies = { "nvim-lua/plenary.nvim" }
        },
        {
            "nvim-telescope/telescope-file-browser.nvim",
            dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" }
        },
        {
            "ThePrimeagen/harpoon",
            branch = "harpoon2",
            dependencies = { "nvim-lua/plenary.nvim" }
        },
        { "lewis6991/gitsigns.nvim" },
        { "neovim/nvim-lspconfig" },
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
                    },
                }
            end
        },
        { "hrsh7th/cmp-nvim-lsp" },
        { "L3MON4D3/LuaSnip" },

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
        { 'airblade/vim-gitgutter' },
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
        {
            'saadparwaiz1/cmp_luasnip',
        },
    },
})

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
end

-- Keymaps
local m = vim.api.nvim_set_keymap
local mf = vim.keymap.set
local opts = { noremap = true, silent = true, }

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

m("n", "gq", "<cmd>nohl<cr>", opts)

m("n", "<Space>", "<Nop>", opts)

mf("n", "<C-k>r", function() vim.lsp.buf.rename() end, opts)
mf("n", "<C-k>m", function() vim.lsp.buf.format() end, opts)
mf("n", "<S-K>", function() vim.lsp.buf.hover() end, opts)
mf("n", "<C-K>.", function() vim.lsp.buf.code_action() end, opts)

mf("n", "gd", function() vim.lsp.buf.definition() end, opts)
mf("n", "gD", function() vim.lsp.buf.declaration() end, opts)
mf("n", "gi", function() vim.lsp.buf.implementation() end, opts)
mf("n", "gI", function() vim.lsp.buf.type_definition() end, opts)
mf("n", "gr", function() vim.lsp.buf.references() end, opts)
mf("n", "gs", function() vim.lsp.buf.signature_help() end, opts)
mf("n", "gl", function() vim.diagnostic.open_float() end, opts)

mf("n", "<C-k>d", function() vim.diagnostic.goto_next() end, opts)
mf("n", "<C-k>D", function() vim.diagnostic.goto_prev() end, opts)

m("n", "<A-e>", "<cmd>:Telescope file_browser<cr>", opts)
-- m("n", "<C-k>fd", "<cmd>:Telescope find_files --hidden<cr>", opts)

vim.lsp.enable("lua_ls")
vim.lsp.enable("rust_analyzer")
vim.lsp.enable("taplo")
vim.lsp.enable("bashls")

local action_state = require "telescope.actions.state"
local actions = require "telescope.actions"
local fb_utils = require "telescope._extensions.file_browser.utils"

local function copy(x)
    require("plenary.job")
        :new({
            command = "sh",
            args = {
                "-c",
                '~/.cargo/bin/salt copy <<<"$0"',
                x,
            },
            on_exit = function(j, return_val)
                if return_val ~= 0 then
                    print("Copy command failed with return code:", return_val)
                    print("stderr:", table.concat(j:stderr_result(), "\n"))
                end
            end,
        })
        :start()
end

local function open(p)
    local quiet = action_state.get_current_picker(p).finder.quiet
    local selections = fb_utils.get_selected_files(p, true)
    if vim.tbl_isempty(selections) then
        fb_utils.notify("actions.open",
            { msg = "No selection to be opened!", level = "INFO", quiet = quiet })
        return
    end

    for _, selection in ipairs(selections) do
        if vim.fn.has("wsl") == 1 then
            require("plenary.job")
                :new({
                    command = "sh",
                    args = {
                        "-c",
                        'y=$(dirname "$0"); z=$(basename "$0"); cd "$y" && explorer.exe "$z"',
                        selection:absolute(),
                    },
                })
                :start()
        else
            require("plenary.job")
                :new({
                    command = "pcmanfm",
                    args = { selection:absolute() },
                })
                :start()
        end
    end
end
local function copy_relative_path(p)
    local quiet = action_state.get_current_picker(p).finder.quiet
    local selections = fb_utils.get_selected_files(p, true)

    if vim.tbl_isempty(selections) then
        fb_utils.notify("actions.open",
            { msg = "No selection to be opened!", level = "INFO", quiet = quiet })
        return
    end

    for _, selection in ipairs(selections) do
        local x = selection:make_relative(vim.fn.getcwd());
        copy(x)
    end
end
local function copy_absolute_path(p)
    local quiet = action_state.get_current_picker(p).finder.quiet
    local selections = fb_utils.get_selected_files(p, true)

    if vim.tbl_isempty(selections) then
        fb_utils.notify("actions.open",
            { msg = "No selection to be opened!", level = "INFO", quiet = quiet })
        return
    end

    for _, selection in ipairs(selections) do
        local x = selection:absolute()
        copy(x)
    end
end
--
local function copy_windows_path(p)
    if vim.fn.has("wsl") ~= 1 then
        return
    end

    local quiet = action_state.get_current_picker(p).finder.quiet
    local selections = fb_utils.get_selected_files(p, true)

    if vim.tbl_isempty(selections) then
        fb_utils.notify("actions.open",
            { msg = "No selection to be opened!", level = "INFO", quiet = quiet })
        return
    end

    for _, selection in ipairs(selections) do
        local r = vim.system(
            {
                "sh",
                "-c",
                'y=$(dirname "$0"); z=$(basename "$0"); cd "$y" && powershell.exe \\(Resolve-Path -LiteralPath "$z"\\).ProviderPath',
                selection:absolute(),
            },
            { text = true }):wait();
        if r.code ~= 0 then
            vim.api.nvim_echo({ "Path command failed because " .. r.stdout, "ErrorMsg" })
            return
        end
        local x = r.stdout
        copy(x)
    end
end

local fb_actions = require "telescope._extensions.file_browser.actions"
require("telescope").setup {
    defaults = {
        mappings = {
            i = {
                ["<C-u>"] = false,
                ["<Esc>"] = actions.close,
                ["<C-c>"] = false,
                ["<A-j>"] = actions.move_selection_next,
                ["<A-k>"] = actions.move_selection_previous,
            },
            n = {
                ["<C-c>"] = actions.close,
            },
        },
    },
    extensions = {
        file_browser = {
            hijack_netrw = true,
            follow_symlinks = true,
            no_ignore = true,
            mappings = {
                ["n"] = {
                    ["f"] = open,
                    ["c"] = copy_relative_path,
                    ["C"] = copy_absolute_path,
                    ["w"] = copy_windows_path,
                    ["n"] = fb_actions.create,
                    ["o"] = false,
                },
                ["i"] = {
                    ["<A-f>"] = open,
                    ["<A-c>"] = copy_relative_path,
                    ["<A-C>"] = copy_absolute_path,
                    ["<A-w>"] = copy_windows_path,
                },
            }
        }
    }
}
require("telescope").load_extension "file_browser"

local tele = require("telescope.builtin")

m("n", "<C-k><S-s>", [[:lua os.execute("source ~/.bashrc; slack_quote")<CR>p]], opts)

mf("n", "<C-k>F", tele.find_files, opts)
mf("n", "<C-k>ff", function()
    tele.live_grep({
        glob_pattern = { "*", "!.git" },
    })
end, opts)
mf("n", "<C-k>fa", function()
    tele.live_grep({
        glob_pattern = { "*.md", "!.git" },
    })
end, opts)
mf("n", "<C-k>fg", tele.live_grep, opts)
mf("n", "<C-k>fd", function()
    tele.find_files({
        hidden = true,
        follow = true,
    })
end, opts)

mf("n", "<C-k>c", '<cmd>let @+ = @%<CR>', opts)
mf("n", "<C-k>C", '<cmd>let @+ = expand("%:p")<CR>', opts)


-- harpoon {
local harpoon = require("harpoon")
harpoon:setup()
mf("n", "<A-a>", function() harpoon:list():add() end)
mf("n", "<A-w>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)

mf("n", "<A-1>", function() harpoon:list():select(1) end)
mf("n", "<A-2>", function() harpoon:list():select(2) end)
mf("n", "<A-3>", function() harpoon:list():select(3) end)
mf("n", "<A-4>", function() harpoon:list():select(4) end)
mf("n", "<A-5>", function() harpoon:list():select(5) end)
mf("n", "<A-6>", function() harpoon:list():select(6) end)
mf("n", "<A-7>", function() harpoon:list():select(7) end)
mf("n", "<A-8>", function() harpoon:list():select(8) end)
mf("n", "<A-9>", function() harpoon:list():select(9) end)

mf("n", "gt", function() harpoon:list():next() end)
mf("n", "gT", function() harpoon:list():prev() end)
-- }
