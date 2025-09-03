-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Enhanced Oil.nvim keymaps
vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
vim.keymap.set("n", "<leader>-", "<CMD>Oil .<CR>", { desc = "Open oil in current directory" })

-- Flash.nvim enhanced motions (configured in flash.lua plugin file)
-- s - Flash jump
-- S - Flash treesitter
-- r - Remote flash (operator-pending)
-- R - Treesitter search
-- <c-s> - Toggle flash search in command mode

-- Format shortcuts (conform.nvim) - only if conform is available
if pcall(require, "conform") then
  vim.keymap.set({ "n", "v" }, "<leader>mp", function()
    require("conform").format({
      lsp_format = "fallback",
      async = false,
      timeout_ms = 1000,
    })
  end, { desc = "Format file or range (in visual mode)" })
end

-- Additional quality of life keymaps
-- Better up/down with wrapped lines
vim.keymap.set({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
vim.keymap.set({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
vim.keymap.set({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })
vim.keymap.set({ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })

-- Better indenting
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

-- Clear search with <esc>
vim.keymap.set({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and clear hlsearch" })

-- Save file
vim.keymap.set({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save file" })
