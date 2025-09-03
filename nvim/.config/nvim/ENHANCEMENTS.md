# Neovim Configuration Enhancements

This document describes the modern plugins and improvements added to your LazyVim configuration.

## 🚀 New Plugins Added

### 1. Oil.nvim - File Manager as Buffers

**Description**: Edit your filesystem like a buffer, making file operations feel natural within Vim.

**Key Features**:
- Edit directories as if they were text files
- Create, rename, delete files/directories with standard Vim editing
- Visual file operations with undo/redo support
- Seamless integration with your existing workflow

**Keymaps**:
- `-` - Open parent directory in oil
- `<leader>-` - Open current directory in oil

**Usage**:
- Navigate to any directory with `-`
- Edit filenames directly in the buffer
- Create new files/directories by typing new names
- Save the buffer with `:w` to apply changes
- Delete files by deleting the line and saving

### 2. Flash.nvim - Enhanced Motion

**Description**: Supercharged navigation with smart labeling and enhanced search.

**Key Features**:
- Lightning-fast 2-character search
- Smart labeling for efficient navigation
- Enhanced f/F/t/T motions
- Treesitter-aware navigation
- Multi-window support

**Keymaps**:
- `s` - Flash jump (normal, visual, operator-pending)
- `S` - Flash treesitter selection
- `r` - Remote flash (operator-pending)
- `R` - Treesitter search (visual, operator-pending)
- `<C-s>` - Toggle flash search in command mode

**Usage Examples**:
- `s` + 2 chars → Jump to location with smart labeling
- `dt` + `s` + chars → Delete to flash target
- `S` → Select treesitter objects with labels

### 3. Enhanced Conform.nvim - Code Formatting

**Description**: Comprehensive code formatting with multiple formatters and format-on-save.

**Supported Languages**:
- **Go**: goimports, gofumpt
- **Python**: isort, black
- **JavaScript/TypeScript**: prettier
- **Lua**: stylua
- **Shell**: shfmt
- **Markdown**: prettier, markdownlint
- **CSS/SCSS/HTML**: prettier
- **JSON/YAML**: prettier
- **Rust**: rustfmt

**Keymaps**:
- `<leader>mp` - Format file or range (visual mode)
- `<leader>uf` - Toggle format-on-save

**Commands**:
- `:FormatEnable` - Enable format-on-save
- `:FormatDisable` - Disable format-on-save
- `:FormatDisable!` - Disable format-on-save for current buffer only
- `:ConformInfo` - Show formatter information

## 🎨 Enhanced Configuration

### Improved Options

**Scrolling & Navigation**:
- `scrolloff=8` - Keep 8 lines above/below cursor
- `sidescrolloff=8` - Keep 8 columns left/right of cursor
- Better wrapped line navigation with j/k

**Visual Improvements**:
- `colorcolumn=80` - Show 80-character guide
- Enhanced `listchars` for better invisible character display
- Improved fold markers and diff characters
- Cursor line only in active window

**Performance Optimizations**:
- `updatetime=200` - Faster completion
- `timeoutlen=300` - Faster key sequence completion
- Optimized for modern terminal features

### Enhanced Autocmds

**Quality of Life**:
- Highlight yanked text briefly
- Auto-resize splits when window is resized
- Close certain file types with `q`
- Auto-create directories when saving files
- Trim trailing whitespace on save

**File Type Specific**:
- Enable spell check and wrap for text files (markdown, gitcommit)
- Better JSON file handling with conceallevel
- Oil.nvim integration with clean UI

## 📝 Usage Tips

### Oil.nvim Workflow
1. Press `-` to open parent directory
2. Navigate like a normal buffer (j/k, search, etc.)
3. Edit filenames directly or add new lines for new files
4. Use visual mode for batch operations
5. Save with `:w` to apply all changes

### Flash.nvim Techniques
1. **Quick jumps**: `s` + 2 characters → select label
2. **Operator support**: `d` + `s` + chars → delete to target
3. **Visual selection**: `S` for treesitter-aware selection
4. **Search integration**: Use `<C-s>` during `/` search for flash labels

### Formatting Workflow
1. Code formats automatically on save (when enabled)
2. Use `<leader>mp` for manual formatting
3. Toggle format-on-save with `<leader>uf`
4. Format specific ranges in visual mode

## 🔧 Customization

All plugins are configured with sensible defaults but can be customized:

- **Oil.nvim**: Edit `/lua/plugins/oil.lua` for keymaps and behavior
- **Flash.nvim**: Edit `/lua/plugins/flash.lua` for labels and timing
- **Conform.nvim**: Edit `/lua/plugins/conform.lua` for formatters and settings

## 🔍 Troubleshooting

**Common Issues**:

1. **Formatters not found**: Run `:Mason` to install missing formatters
2. **Oil.nvim not opening**: Check file permissions and current directory
3. **Flash.nvim not working**: Ensure you're using the correct key combinations

**Debug Commands**:
- `:ConformInfo` - Check formatter status
- `:Mason` - Manage formatters and LSP servers
- `:Lazy` - Manage plugins
- `:checkhealth` - Comprehensive health check

## 🎯 Next Steps

Consider these additional enhancements:
- Configure language-specific formatting rules
- Add custom Oil.nvim keymaps for your workflow
- Explore Flash.nvim's treesitter integration
- Set up project-specific formatter configurations

All configurations maintain full compatibility with your existing LazyVim setup and follow LazyVim conventions.