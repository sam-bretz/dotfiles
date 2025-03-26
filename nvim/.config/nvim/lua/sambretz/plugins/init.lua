local opts = { noremap = true, silent = true }
vim.api.nvim_set_keymap('n', '<leader>gd', '<cmd>Telescope lsp_definitions<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>gr', '<cmd>Telescope lsp_references<CR>', opts)

return {
  "christoomey/vim-tmux-navigator"
}


