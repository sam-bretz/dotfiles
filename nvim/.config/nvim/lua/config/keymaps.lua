-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Neotest
vim.api.nvim_set_keymap("n", "<leader>tn", ':lua require("neotest").run.run()<CR>', { noremap = true, silent = true })

vim.api.nvim_set_keymap(
  "n",
  "<leader>tf",
  ':lua require("neotest").run.run(vim.fn.expand("%"))<CR>',
  { noremap = true, silent = true }
)

vim.api.nvim_set_keymap(
  "n",
  "<leader>to",
  ':lua require("neotest").output.open()<CR>',
  { noremap = true, silent = true }
)

vim.api.nvim_set_keymap(
  "n",
  "<leader>tp",
  ':lua require("neotest").output_panel.toggle()<CR>',
  { noremap = true, silent = true }
)

vim.api.nvim_set_keymap(
  "n",
  "<leader>ts",
  ':lua require("neotest").summary.toggle()<CR>',
  { noremap = true, silent = true }
)
