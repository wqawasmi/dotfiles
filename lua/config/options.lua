-- RANDOM OPTIONS
-- Tabs suck. Use spaces.
vim.opt.expandtab = true -- Convert tabs to spaces
vim.opt.shiftwidth = 4   -- Number of spaces per indentation level
vim.opt.tabstop = 4      -- Number of spaces a tab counts for
vim.opt.softtabstop = 4  -- Make backspace treat spaces like tabs

-- Set up line numbers
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true -- Highlight the current line

-- Highlight the current line number with a different color
vim.cmd [[
  hi CursorLineNr guifg=#ffcc00 gui=bold
]]

-- Fast Quit
vim.keymap.set("n", "Q", ":qa<CR>", { noremap = true, silent = true })

-- SESSION MANAGEMENT
local resession = require("resession")
resession.setup({
    autosave = {
        enabled = true,
        interval = 60,
        notify = true,
    },
})

vim.keymap.set("n", "<leader>ss", resession.save)
vim.keymap.set("n", "<leader>sl", resession.load)
vim.keymap.set("n", "<leader>sd", resession.delete)

vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
        -- Only load the session if nvim was started with no args and without reading from stdin
        if vim.fn.argc(-1) == 0 and not vim.g.using_stdin then
            -- Save these to a different directory, so our manual sessions don't get polluted
            resession.load(vim.fn.getcwd(), { dir = "dirsession", silence_errors = true })
        end
    end,
    nested = true,
})
vim.api.nvim_create_autocmd("VimLeavePre", {
    callback = function()
        resession.save(vim.fn.getcwd(), { dir = "dirsession", notify = false })
    end,
})
vim.api.nvim_create_autocmd('StdinReadPre', {
    callback = function()
        -- Store this for later
        vim.g.using_stdin = true
    end,
})

-- TABLINE CONFIG
vim.opt.showtabline = 2

-- NAVIGATION
-- Move line down with J
vim.keymap.set("n", "J", ":m .+1<CR>==", { noremap = true, silent = true })
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { noremap = true, silent = true })

-- Move line up with K
vim.keymap.set("n", "K", ":m .-2<CR>==", { noremap = true, silent = true })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { noremap = true, silent = true })

-- HARPOON CONFIG
local harpoon = require("harpoon.ui")
local harpoon_mark = require("harpoon.mark")
vim.keymap.set("n", "<leader>ha", function() harpoon_mark.add_file() end, { desc = "Add file to Harpoon" })
vim.keymap.set("n", "<leader>hh", function() harpoon.toggle_quick_menu() end, { desc = "Open Harpoon menu" })

-- Jump between pooned files
vim.keymap.set("n", "<leader>1", function() harpoon.nav_file(1) end, { desc = "Go to Harpoon file 1" })
vim.keymap.set("n", "<leader>2", function() harpoon.nav_file(2) end, { desc = "Go to Harpoon file 2" })
vim.keymap.set("n", "<leader>3", function() harpoon.nav_file(3) end, { desc = "Go to Harpoon file 3" })
vim.keymap.set("n", "<leader>4", function() harpoon.nav_file(4) end, { desc = "Go to Harpoon file 4" })

-- Cycle through harpooned files
vim.keymap.set("n", "<leader>hn", function() harpoon.nav_next() end, { desc = "Next Harpoon file" })
vim.keymap.set("n", "<leader>hp", function() harpoon.nav_prev() end, { desc = "Previous Harpoon file" })
vim.keymap.set("n", "<Space><Space>", "<C-^>", { noremap = true, silent = true })

-- LSP configurations
vim.keymap.set("v", "<leader>f", function()
    vim.lsp.buf.format()
end, { noremap = true, silent = true, desc = "Format selection using LSP" })



-- TERMINAL CONFIGURATIONS
local Terminal = require("toggleterm.terminal").Terminal

-- Floating Terminal
local float_term = Terminal:new({ direction = "float" })
vim.keymap.set("n", "<leader>tf", function() float_term:toggle() end,
    { noremap = true, silent = true, desc = "Toggle Floating Terminal" })

-- Vertical Terminal
local vertical_term = Terminal:new({ direction = "vertical", size = vim.o.columns * 0.4 })
vim.keymap.set("n", "<leader>tv", function() vertical_term:toggle() end,
    { noremap = true, silent = true, desc = "Toggle Vertical Terminal" })

-- Horizontal Terminal
local horizontal_term = Terminal:new({ direction = "horizontal", size = 15 })
vim.keymap.set("n", "<leader>th", function() horizontal_term:toggle() end,
    { noremap = true, silent = true, desc = "Toggle Horizontal Terminal" })

-- Global Toggle (F6) in All Modes
vim.keymap.set({ "n", "i", "t" }, "<F7>", "<cmd>ToggleTerm<CR>",
    { noremap = true, silent = true, desc = "Toggle Terminal Visibility" })
