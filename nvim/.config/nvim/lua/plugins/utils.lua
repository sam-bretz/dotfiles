-- Utility plugins configuration

-- Which-key
require("which-key").setup({
  preset = "modern",
  delay = 500,
  filter = function(mapping)
    return true
  end,
  spec = {},
  notify = true,
  triggers = {
    { "<auto>", mode = "nxso" },
  },
})

-- Additional keymaps for which-key hints
local wk = require("which-key")
wk.add({
  { "<leader>f", group = "Find" },
  { "<leader>h", group = "Harpoon" },
  { "<leader>ha", desc = "Add File to Harpoon" },
  { "<leader>hh", desc = "Toggle Harpoon Menu" },
  { "<leader>hq", desc = "Harpoon File 1" },
  { "<leader>hw", desc = "Harpoon File 2" },
  { "<leader>he", desc = "Harpoon File 3" },
  { "<leader>hr", desc = "Harpoon File 4" },
  { "<leader>w", group = "Workspace" },
  { "<leader>c", desc = "Close Buffer" },
  { "<leader>q", desc = "Quit" },
  { "<leader>r", group = "Rename" },
  { "<leader>t", group = "Toggle" },
  { "<leader>g", group = "Git" },
  { "<leader>e", desc = "Toggle File Explorer" },
  { "<leader>o", desc = "Focus File Explorer" },
  { "[", group = "Previous" },
  { "]", group = "Next" },
  { "g", group = "Go to" },
})