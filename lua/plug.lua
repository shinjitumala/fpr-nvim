local ok, env = pcall(require, "env")
env = ok and env or {}

local lsp = env.lsp == true;

local cmp_opts = function()
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
            (lsp and { name = 'nvim_lsp' } or nil),
        },
    }
end

local tree_sitter = function()
    require("tree-sitter-manager").setup({
        auto_install = true,
    })
end

local comment = {
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
};


return {
    { "nvim-telescope/telescope.nvim", dependencies = { "nvim-lua/plenary.nvim" } },
    { "nvim-telescope/telescope-file-browser.nvim", dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" } },

    { "ThePrimeagen/harpoon", branch = "harpoon2", dependencies = { "nvim-lua/plenary.nvim" } },

    { "lewis6991/gitsigns.nvim" },
    { 'airblade/vim-gitgutter' },

    { "hrsh7th/nvim-cmp", opts = cmp_opts },

    { "L3MON4D3/LuaSnip" },
    { 'saadparwaiz1/cmp_luasnip', },

    { "romus204/tree-sitter-manager.nvim", config = tree_sitter },
    { "catppuccin/nvim", name = "catppuccin", },

    { "neovim/nvim-lspconfig", enabled = lsp },
    { "hrsh7th/cmp-nvim-lsp", enabled = lsp },

    { "numToStr/Comment.nvim", opts = comment },
}
