# Modern CLI Tools Setup

A comprehensive collection of modern command-line tools that enhance productivity and provide a better terminal experience.

## 🚀 Quick Start

```bash
# Run the complete setup
./setup-modern-cli.sh

# Or preview what would be installed
./setup-modern-cli.sh --dry-run

# Install tools only (no config setup)
./brew/install-modern-cli.sh
```

## 🛠 Tools Included

### Core Enhanced Utilities
- **[eza](https://github.com/eza-community/eza)** - Modern replacement for `ls` with colors and icons
- **[bat](https://github.com/sharkdp/bat)** - `cat` with syntax highlighting and Git integration
- **[fd](https://github.com/sharkdp/fd)** - Fast and user-friendly alternative to `find`
- **[ripgrep](https://github.com/BurntSushi/ripgrep)** - Ultra-fast text search tool
- **[zoxide](https://github.com/ajeetdsouza/zoxide)** - Smarter `cd` command that learns your habits
- **[atuin](https://github.com/atuinsh/atuin)** - Better shell history with sync and search
- **[dust](https://github.com/bootandy/dust)** - More intuitive version of `du`
- **[duf](https://github.com/muesli/duf)** - Better `df` alternative with colors

### System Monitoring
- **[btop](https://github.com/aristocratos/btop)** - Resource monitor (better than htop/top)
- **[procs](https://github.com/dalance/procs)** - Modern replacement for `ps`
- **[bandwhich](https://github.com/imsnif/bandwhich)** - Network utilization by process
- **[bottom](https://github.com/ClementTsang/bottom)** - Alternative to top and htop

### Development Tools
- **[lazygit](https://github.com/jesseduffield/lazygit)** - Terminal UI for Git
- **[delta](https://github.com/dandavison/delta)** - Better git diff viewer
- **[gitui](https://github.com/extrawurst/gitui)** - Terminal UI for Git (alternative)
- **[hyperfine](https://github.com/sharkdp/hyperfine)** - Command-line benchmarking tool
- **[tokei](https://github.com/XAMPPRocky/tokei)** - Fast code statistics
- **[glow](https://github.com/charmbracelet/glow)** - Markdown renderer for the terminal

### File Management & Navigation
- **[yazi](https://github.com/sxyazi/yazi)** - Terminal file manager
- **[broot](https://github.com/Canop/broot)** - Better way to navigate directories
- **[trash](https://github.com/sindresorhus/trash)** - Safe `rm` replacement

### Terminal Enhancement
- **[starship](https://starship.rs/)** - Fast and customizable prompt
- **[zellij](https://github.com/zellij-org/zellij)** - Terminal workspace manager

### Utilities
- **[tldr](https://github.com/tldr-pages/tldr)** - Simplified man pages
- **[neofetch](https://github.com/dylanaraps/neofetch)** - System information
- **[httpie](https://httpie.io/)** - HTTP client
- **[aria2](https://aria2.github.io/)** - Download manager

## 📁 Project Structure

```
~/.dotfiles/
├── brew/
│   ├── Brewfile                    # Enhanced with modern CLI tools
│   └── install-modern-cli.sh       # Installation script
├── configs/
│   ├── starship/starship.toml      # Starship prompt configuration
│   ├── atuin/config.toml           # Atuin history configuration  
│   ├── yazi/yazi.toml              # Yazi file manager configuration
│   ├── btop/btop.conf              # Btop system monitor configuration
│   └── broot/config.hjson          # Broot directory navigator configuration
├── zsh/
│   └── aliases/modern-cli.sh       # Modern CLI tool integrations
├── setup-modern-cli.sh             # Complete setup script
└── README-modern-cli.md            # This file
```

## ⚙️ Configuration

### Shell Integration

The tools are integrated into your zsh configuration with:

1. **Smart fallbacks** - If a modern tool isn't available, falls back to traditional tools
2. **Preserved aliases** - Your existing aliases continue to work
3. **Enhanced functionality** - Additional features and shortcuts for modern tools

### Key Features

#### Enhanced File Operations
```bash
# Modern ls with eza
ls          # Colored output with icons
ll          # Long format with git status
la          # All files including hidden
lt          # Tree view

# Enhanced cat with bat
cat file.py # Syntax highlighted output
```

#### Smart Navigation
```bash
# Zoxide (smart cd)
z project   # Jump to any directory containing "project"
zi          # Interactive directory selection
zd          # Directory selection with preview

# Yazi file manager
ya          # Launch file manager that can change directory on exit
```

#### Improved History
```bash
# Atuin (smart history)
Ctrl+R      # Fuzzy search through history
atuin sync  # Sync history across machines
```

#### Better Git Experience
```bash
# Lazygit
lg          # Launch git TUI

# Delta (enhanced git diff)
git diff    # Automatically uses delta for better diffs
```

### Prompt Options

You can choose between Starship and Powerlevel10k:

```bash
# To use Starship (modern, fast prompt)
export PREFER_STARSHIP=true

# To stick with Powerlevel10k (if configured)
# Just leave PREFER_STARSHIP unset
```

## 🔧 Installation Options

### Complete Setup
```bash
./setup-modern-cli.sh
```

### Individual Components
```bash
# Install tools only
./brew/install-modern-cli.sh

# Setup configurations only  
./setup-modern-cli.sh --no-install

# Preview changes
./setup-modern-cli.sh --dry-run
```

### Advanced Options
```bash
# Force overwrite existing configs
./setup-modern-cli.sh --force

# Skip backups
./setup-modern-cli.sh --no-backup

# Verify installation
./setup-modern-cli.sh --verify
```

## 🛡 Backup & Safety

### Automatic Backups
The setup script automatically backs up existing configurations to:
```
~/.dotfiles/backup/YYYYMMDD_HHMMSS/
```

### Restore from Backup
```bash
./setup-modern-cli.sh --restore 20240130_120000
```

### Fallback Mechanisms
- All modern tools have traditional fallbacks
- Existing aliases are preserved for compatibility
- Configuration errors won't break your shell

## 📚 Usage Examples

### File Operations
```bash
# List files with modern tools
ls                    # eza with colors and icons
ll README.md         # Long format with git status
cat config.yaml      # Syntax highlighted with bat
find . -name "*.rs"  # Fast search with fd
grep "TODO" src/     # Fast text search with ripgrep
```

### System Monitoring
```bash
top                  # btop - beautiful system monitor
ps aux              # procs - modern process list  
du -h               # dust - intuitive disk usage
df -h               # duf - colorful disk usage
```

### Development Workflow
```bash
lg                  # Launch lazygit
git diff            # Enhanced diff with delta
glow README.md      # Render markdown
tokei              # Code statistics
hyperfine "cmd1" "cmd2"  # Benchmark commands
```

### Navigation & Files
```bash
z project          # Smart directory jumping
ya                 # File manager with directory change
br                 # Directory tree navigator
```

## 🚨 Troubleshooting

### Common Issues

1. **Command not found after installation**
   ```bash
   # Reload shell configuration
   source ~/.zshrc
   ```

2. **Tools installed but not working**
   ```bash
   # Check installation status
   ./setup-modern-cli.sh --verify
   check-modern-tools
   ```

3. **Conflicts with existing tools**
   ```bash
   # Check which tool is being used
   which ls
   type ls
   ```

### Reset to Defaults
```bash
# Restore from backup
./setup-modern-cli.sh --restore BACKUP_DATE

# Or manually remove modern aliases
# Edit ~/.dotfiles/zsh/aliases/modern-cli.sh
```

## 🤝 Customization

### Adding Your Own Tools

1. Add to `Brewfile`:
   ```ruby
   brew "your-tool"
   ```

2. Add integration to `zsh/aliases/modern-cli.sh`:
   ```bash
   if command -v your-tool >/dev/null 2>&1; then
       alias oldtool='your-tool'
   fi
   ```

3. Add configuration to `configs/` if needed

### Custom Configurations

All configurations are in `~/.dotfiles/configs/` and can be modified:
- Starship: `configs/starship/starship.toml`
- Atuin: `configs/atuin/config.toml`
- Yazi: `configs/yazi/yazi.toml`
- Btop: `configs/btop/btop.conf`
- Broot: `configs/broot/config.hjson`

## 📖 Quick Reference

Run `modern-help` in your terminal for a quick reference of all available commands and shortcuts.

## 🔗 Links

- [Starship Documentation](https://starship.rs/config/)
- [Atuin Documentation](https://atuin.sh/docs/)
- [Yazi Documentation](https://yazi-rs.github.io/docs/)
- [Btop Documentation](https://github.com/aristocratos/btop)
- [Modern Unix Tools](https://github.com/ibraheemdev/modern-unix)