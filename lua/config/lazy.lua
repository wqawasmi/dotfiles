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

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Setup lazy.nvim
require("lazy").setup({
    spec = {
        -- import your plugins
        {
            "lewis6991/impatient.nvim",
            config = function()
                require("impatient")
            end,
        },
        { import = "plugins" },
        {
            "stevearc/resession.nvim",
            opts = {}
        },
        {
            "williamboman/mason.nvim",
            config = function()
                require("mason").setup()
            end,
        },
        {
            "pmizio/typescript-tools.nvim",
            dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
            opts = {},
        },
        {
            "neovim/nvim-lspconfig",
            config = function()
                local lspconfig = require("lspconfig")

                -- Setup each installed LSP
                lspconfig.lua_ls.setup({})
                -- lspconfig.ts_ls.setup({})
                lspconfig.pyright.setup({})
            end,
        },
        {
            "folke/which-key.nvim",
            config = function()
                require("which-key").setup()
            end,
        },
        {
            "ThePrimeagen/harpoon",
            dependencies = { "nvim-lua/plenary.nvim" },
        },
        {
            'nvimdev/dashboard-nvim',
            event = 'VimEnter',
            config = function()
                require('dashboard').setup {
                    -- config
                }
            end,
            dependencies = { { 'nvim-tree/nvim-web-devicons' } }
        },
        { "akinsho/toggleterm.nvim", version = "*", config = true }

    },
    -- Configure any other settings here. See the documentation for more details.
    -- colorscheme that will be used when installing plugins.
    install = { colorscheme = { "habamax" } },
    -- automatically check for plugin updates
    checker = { enabled = true },
})
