-- Define default options
local default_opts = { noremap = true, silent = true }

-- Center search results
vim.keymap.set("n", "n", "nzz", default_opts)
vim.keymap.set("n", "N", "Nzz", default_opts)

-- Better indenting
vim.keymap.set("v", "<", "<gv", default_opts)
vim.keymap.set("v", ">", ">gv", default_opts)

-- Switch buffers
vim.keymap.set("n", "<S-h>", ":bprevious<CR>", default_opts)
vim.keymap.set("n", "<S-l>", ":bnext<CR>", default_opts)

-- Cancel search highlighting with ESC
vim.keymap.set("n", "<ESC>", ":nohlsearch<Bar>:echo<CR>", default_opts)

-- Move selected line/block of text in visual mode
vim.keymap.set("x", "K", ":move '<-2<CR>gv-gv", default_opts)
vim.keymap.set("x", "J", ":move '>+1<CR>gv-gv", default_opts)

-- Resize panes
vim.keymap.set("n", "<Left>", ":vertical resize +1<CR>", default_opts)
vim.keymap.set("n", "<Right>", ":vertical resize -1<CR>", default_opts)
vim.keymap.set("n", "<Up>", ":resize -1<CR>", default_opts)
vim.keymap.set("n", "<Down>", ":resize +1<CR>", default_opts)

-- Quit
vim.keymap.set("n", "<C-o>", ":q<CR>", default_opts)
vim.keymap.set("n", "<C-w>", ":qa<CR>", default_opts)

