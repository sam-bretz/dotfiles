" Neovim Configuration with vim-plug
" Simple, trusted, and maintainable

" Auto-install vim-plug if not found
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Plugin definitions
call plug#begin(data_dir . '/plugged')

" Dependencies
Plug 'nvim-lua/plenary.nvim'

" Colorscheme
Plug 'neanias/everforest-nvim'

" File navigation and search
Plug 'nvim-telescope/telescope.nvim', { 'branch': '0.1.x' }
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'ThePrimeagen/harpoon', { 'branch': 'harpoon2' }
Plug 'nvim-tree/nvim-tree.lua'

" LSP and completion
Plug 'neovim/nvim-lspconfig'
Plug 'williamboman/mason.nvim'
Plug 'williamboman/mason-lspconfig.nvim'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'L3MON4D3/LuaSnip'
Plug 'saadparwaiz1/cmp_luasnip'

" Syntax and editing
Plug 'nvim-treesitter/nvim-treesitter', { 'do': ':TSUpdate' }
Plug 'nvim-treesitter/nvim-treesitter-textobjects'
Plug 'kylechui/nvim-surround'
Plug 'numToStr/Comment.nvim'
Plug 'windwp/nvim-autopairs'

" Git integration
Plug 'lewis6991/gitsigns.nvim'
Plug 'tpope/vim-fugitive'

" UI enhancements
Plug 'nvim-lualine/lualine.nvim'
Plug 'nvim-tree/nvim-web-devicons'

" Tmux integration
Plug 'christoomey/vim-tmux-navigator'

" Utilities
Plug 'folke/which-key.nvim'

call plug#end()

" Source lua configurations
lua require('core.options')
lua require('core.keymaps')
lua require('core.autocmds')

" Load plugin configurations only if plugins are installed
if !empty(glob(data_dir . '/plugged'))
  lua require('plugins.colorscheme')
  lua require('plugins.telescope')
  lua require('plugins.lsp')
  lua require('plugins.treesitter')
  lua require('plugins.harpoon')
  lua require('plugins.completion')
  lua require('plugins.git')
  lua require('plugins.ui')
  lua require('plugins.utils')
endif