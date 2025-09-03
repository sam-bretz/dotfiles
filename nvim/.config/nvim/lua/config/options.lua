-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

local opt = vim.opt

-- Enhanced editing options
opt.scrolloff = 8 -- Keep 8 lines above and below cursor
opt.sidescrolloff = 8 -- Keep 8 columns left and right of cursor
opt.cursorline = true -- Highlight current line
opt.relativenumber = true -- Relative line numbers
opt.number = true -- Show line numbers
opt.wrap = false -- Disable line wrap
opt.linebreak = true -- Break lines at word boundaries if wrap is enabled

-- Better search
opt.ignorecase = true -- Case insensitive searching
opt.smartcase = true -- Case sensitive if uppercase present
opt.hlsearch = true -- Highlight search results
opt.incsearch = true -- Show matches while typing

-- Better completion
opt.completeopt = { "menu", "menuone", "noselect" }
opt.pumheight = 10 -- Maximum popup menu height

-- Formatting and whitespace
opt.expandtab = true -- Use spaces instead of tabs
opt.shiftwidth = 2 -- Size of an indent
opt.tabstop = 2 -- Number of spaces tabs count for
opt.softtabstop = 2 -- Number of spaces tabs count for in insert mode
opt.smartindent = true -- Insert indents automatically
opt.shiftround = true -- Round indent to multiple of 'shiftwidth'

-- File handling
opt.undofile = true -- Enable persistent undo
opt.backup = false -- Don't create backup files
opt.writebackup = false -- Don't create backup before writing
opt.swapfile = false -- Don't create swap files
opt.updatetime = 200 -- Faster completion
opt.timeoutlen = 300 -- Faster key sequence completion

-- Display improvements
opt.termguicolors = true -- True color support
opt.signcolumn = "yes" -- Always show sign column
opt.colorcolumn = "80" -- Show column at 80 characters
opt.list = true -- Show invisible characters
opt.listchars = {
  tab = "→ ",
  eol = "¬",
  trail = "⋅",
  extends = "❯",
  precedes = "❮",
}
opt.fillchars = {
  foldopen = "▾",
  foldclose = "▸",
  fold = " ",
  foldsep = " ",
  diff = "╱",
  eob = " ",
}

-- Folding
if vim.fn.has("nvim-0.10") == 1 then
  opt.foldmethod = "expr"
  opt.foldexpr = "nvim_treesitter#foldexpr()"
else
  opt.foldmethod = "indent"
end
opt.foldlevel = 99
opt.foldtext = ""

-- Window splits
opt.splitbelow = true -- Put new windows below current
opt.splitright = true -- Put new windows right of current
opt.splitkeep = "screen" -- Keep screen position when splitting

-- Command line
opt.cmdheight = 1 -- Height of command line
opt.showcmd = true -- Show partial commands
opt.showmode = false -- Don't show mode (status line shows it)

-- Mouse and clipboard
opt.mouse = "a" -- Enable mouse support
opt.clipboard = "unnamedplus" -- Use system clipboard

-- Performance
opt.lazyredraw = false -- Don't redraw during macros (can cause issues)
opt.ttyfast = true -- Fast terminal

-- Spell checking (enable for specific file types in autocmds)
opt.spell = false
opt.spelllang = { "en_us" }
