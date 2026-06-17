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

local ok, env = pcall(require, "env")
env = ok and env or {}

local lsp = env.lsp == true;

-- Setup lazy.nvim
require("lazy").setup({ { import = "plug" } })

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
    }
})
vim.cmd.colorscheme "catppuccin"
vim.api.nvim_set_hl(0, "@markup.raw.block.markdown", { link = "Text" })
vim.api.nvim_set_hl(0, "@markup.raw.markdown_inline", { link = "Text" })

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
o.signcolumn = 'yes'
o.termguicolors = true
o.autoread = true
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
    command = "if mode() != 'c' | checktime | endif",
    pattern = "*",
})

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

local m = function(mode, key, f, desc)
    vim.keymap.set(mode, key, f, { noremap = true, silent = true, desc = desc })
end

local wnav = {
    "l", "h", "k", "j", "L", "H", "K", "J",
}
for _, n in ipairs(wnav) do
    local k = "<C-k>" .. n
    local c = "<Cmd>winc " .. n .. "<CR>"
    m("n", k, c)
    m("t", k, c)
end

m("n", "gq", "<cmd>nohl<cr>")
m("n", "<Space>", "<Nop>")
m("n", "<A-e>", "<cmd>:Telescope file_browser<cr>")
-- m("n", "<C-k>fd", "<cmd>:Telescope find_files --hidden<cr>")

m("n", "<C-k>r", vim.lsp.buf.rename)
m("n", "<C-k>m", vim.lsp.buf.format)
m("n", "<S-K>", vim.lsp.buf.hover)
m("n", "<C-K>.", vim.lsp.buf.code_action)

m("n", "gd", vim.lsp.buf.definition)
m("n", "gD", vim.lsp.buf.declaration)
m("n", "gi", vim.lsp.buf.implementation)
m("n", "gI", vim.lsp.buf.type_definition)
m("n", "gr", vim.lsp.buf.references)
m("n", "gs", vim.lsp.buf.signature_help)
m("n", "gl", vim.diagnostic.open_float)

m("n", "<C-k>d", function() vim.diagnostic.jump({ count = 1 }) end)
m("n", "<C-k>D", function() vim.diagnostic.jump({ count = -1 }) end)

if lsp then
    vim.lsp.enable("lua_ls")
    -- vim.lsp.enable("rust_analyzer")
    -- vim.lsp.config("rust_analyzer", {
    --     -- Other Configs ...
    --     settings = {
    --         ["rust-analyzer"] = {
    --             cargo = {
    --                 features = "all", -- Enable all features
    --             },
    --             -- Other Settings ...
    --             --
    --             procMacro = {
    --                 ignored = {
    --                     leptos_macro = {
    --                         -- optional: --
    --                         -- "component",
    --                         "server",
    --                     },
    --                 },
    --             },
    --         },
    --     }
    -- })
    vim.lsp.enable("taplo")
    vim.lsp.enable("bashls")
    vim.lsp.enable("ts_ls")
    vim.lsp.config["ts_ls"] = {
        root_dir = function(_, callback)
            local deno_dir = vim.fs.root(0, { "deno.json", "deno.jsonc" })
            local root_dir = vim.fs.root(0, { "tsconfig.json", "jsconfig.json", "package.json" })

            if root_dir and deno_dir == nil then
                callback(root_dir)
            end
        end
    }
    vim.lsp.enable("denols")
    vim.lsp.config["denols"] = {
        root_dir = function(_, callback)
            local root_dir = vim.fs.root(0, { "deno.json", "deno.jsonc" })

            if root_dir then
                callback(root_dir)
            end
        end
    }
    vim.lsp.enable("html")
    vim.lsp.enable("jsonls")
    vim.lsp.enable("clangd")
    vim.lsp.enable("cmake")
    vim.lsp.enable("cssls")
    vim.lsp.enable("html")
    vim.lsp.enable("powershell_es")
end

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
            vim.notify("Path command failed because " .. r.stdout, vim.log.levels.ERROR)
            return
        end
        local x = r.stdout
        copy(x)
    end
end

local function copy_path_with_selection(absolute)
    local path = absolute and vim.fn.expand('%:p') or vim.fn.expand('%')
    local mode = vim.api.nvim_get_mode().mode
    local selection = nil

    if mode == 'v' or mode == 'V' or mode == '\22' then
        local saved_reg = vim.fn.getreg('"')
        local saved_regtype = vim.fn.getregtype('"')
        vim.cmd('noau normal! "vy')
        selection = vim.fn.getreg('v')
        vim.fn.setreg('"', saved_reg, saved_regtype)
    end

    local final_text
    if selection and selection ~= "" then
        if mode == 'V' then
            final_text = string.format("`%s`:\n```\n%s```", path, selection)
        else
            final_text = string.format("`%s`:\n```\n%s\n```", path, selection)
        end
    else
        final_text = path
    end
    copy(final_text)
end

m({ "n", "v" }, "<A-c>", function() copy_path_with_selection(false) end, "Copy relative file path and current selection to clipboard")
m({ "n", "v" }, "<A-C>", function() copy_path_with_selection(true) end, "Copy absolute file path and current selection to clipboard")

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
        layout_config = {
            horizontal = {
                width = { padding = 0 },
                height = { padding = 0 },
                preview_width = 0.5
            }
        },
        borderchars = { " ", " ", " ", " ", " ", " ", " ", " " }
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

m("n", "<C-k><S-s>", [[:lua os.execute("source ~/.bashrc; slack_quote")<CR>p]])

m("n", "<C-k>F", tele.find_files)
m("n", "<C-k>ff", function()
    tele.live_grep({
        glob_pattern = { "*", "!.git" },
    })
end)
m("n", "<C-k>fa", function()
    tele.live_grep({
        glob_pattern = { "*.md", "!.git" },
    })
end)
m("n", "<C-k>fg", tele.live_grep)
m("n", "<C-k>fd", function()
    tele.find_files({
        hidden = true,
        follow = true,
    })
end)

m("n", "<C-k>c", '<cmd>let @+ = @%<CR>')
m("n", "<C-k>C", '<cmd>let @+ = expand("%:p")<CR>')


-- harpoon {
local harpoon = require("harpoon")
harpoon:setup()
m("n", "<A-a>", function() harpoon:list():add() end)
m("n", "<A-w>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)

m("n", "<A-1>", function() harpoon:list():select(1) end)
m("n", "<A-2>", function() harpoon:list():select(2) end)
m("n", "<A-3>", function() harpoon:list():select(3) end)
m("n", "<A-4>", function() harpoon:list():select(4) end)
m("n", "<A-5>", function() harpoon:list():select(5) end)
m("n", "<A-6>", function() harpoon:list():select(6) end)
m("n", "<A-7>", function() harpoon:list():select(7) end)
m("n", "<A-8>", function() harpoon:list():select(8) end)
m("n", "<A-9>", function() harpoon:list():select(9) end)

m("n", "gt", function() harpoon:list():next() end)
m("n", "gT", function() harpoon:list():prev() end)
-- }

-- fpr-snip {
local function load_salt_snip()
    local ls = require("luasnip")
    local s  = ls.snippet
    local f  = ls.function_node
    local t  = ls.text_node

    local function shell(cmd)
        local handle, err = io.popen(cmd)
        if not handle then
            return nil, err
        end
        local output = handle:read("*a")
        handle:close()
        return output
    end

    local output, err = shell("salt-snip --list true")
    if not output then
        vim.notify("salt-snip: failed to run: " .. (err or "unknown error"), vim.log.levels.ERROR)
        return
    end

    local ok, entries = pcall(vim.json.decode, output)
    if not ok or type(entries) ~= "table" then
        vim.notify("salt-snip: failed to parse JSON output", vim.log.levels.ERROR)
        return
    end

    local by_lang = {}
    for _, entry in ipairs(entries) do
        local key   = entry.key
        local desc  = entry.desc or ""
        local langs = entry.languages or {}
        local snip  = s(
            {
                trig = key,
                desc = desc,
            },
            f(function(_, _, _)
                local body, serr = shell("salt-snip " .. vim.fn.shellescape(key) .. " --interactive false")
                if not body or body == "" then
                    vim.notify("salt-snip: no output for key: " .. key .. (serr and (": " .. serr) or ""),
                        vim.log.levels.WARN)
                    return { "" }
                end
                local lines = {}
                local b = body:match("\n$") and body or body .. "\n"
                for x in b:gmatch("([^\n\r]*)\r?\n") do
                    table.insert(lines, x)
                end
                return lines
            end, {}, {})
        )

        for _, lang in ipairs(langs) do
            if not by_lang[lang] then
                by_lang[lang] = {}
            end
            table.insert(by_lang[lang], snip)
        end
    end
    for lang, snips in pairs(by_lang) do
        ls.add_snippets(lang, snips, { key = "salt-snip-" .. lang })
    end
end

load_salt_snip()
-- }
