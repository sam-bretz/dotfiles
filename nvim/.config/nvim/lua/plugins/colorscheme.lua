-- Colorscheme configuration
local ok, everforest = pcall(require, "everforest")
if ok then
  everforest.setup({
    background = "medium",
    transparent_background_level = 0,
    italics = true,
    disable_italic_comments = false,
  })
  vim.cmd("colorscheme everforest")
else
  vim.cmd("colorscheme default")
end