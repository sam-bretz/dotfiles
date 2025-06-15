-- Harpoon configuration
local harpoon = require("harpoon")

-- Initialize harpoon
harpoon:setup()

-- Keymaps (matching your existing configuration)
local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Add file to harpoon
keymap("n", "<leader>ha", function()
  harpoon:list():add()
end, opts)

-- Toggle harpoon menu
keymap("n", "<leader>hh", function()
  harpoon.ui:toggle_quick_menu(harpoon:list())
end, opts)

-- Navigate to harpooned files
keymap("n", "<leader>hq", function()
  harpoon:list():select(1)
end, opts)

keymap("n", "<leader>hw", function()
  harpoon:list():select(2)
end, opts)

keymap("n", "<leader>he", function()
  harpoon:list():select(3)
end, opts)

keymap("n", "<leader>hr", function()
  harpoon:list():select(4)
end, opts)

-- Toggle previous & next buffers stored within Harpoon list
keymap("n", "<C-S-P>", function()
  harpoon:list():prev()
end, opts)

keymap("n", "<C-S-N>", function()
  harpoon:list():next()
end, opts)