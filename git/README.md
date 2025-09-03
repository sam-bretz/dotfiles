# Enhanced Git Workflow

A comprehensive Git configuration with modern tools and productivity enhancements.

## 🚀 Features

### Core Tools
- **Git** - Latest version with optimized configuration
- **Delta** - Enhanced diff viewer with syntax highlighting
- **LazyGit** - Modern terminal-based Git interface
- **GitUI** - Fast Rust-based Git TUI
- **GitHub CLI** - Command-line GitHub integration

### Key Enhancements
- ✨ 50+ productivity aliases and functions
- 🎨 Beautiful diffs with Delta integration
- ⚡ Fast terminal interfaces (LazyGit & GitUI)
- 🔧 Optimized Git configuration with modern defaults
- 🌿 Advanced Git worktree management
- 🔐 SSH-first approach with GitHub integration
- 📊 Enhanced status displays with emojis
- 🏷️ Conventional commit support

## 📁 Structure

```
git/
├── .gitconfig              # Main Git configuration with aliases
├── setup.sh               # Installation and setup script
├── README.md              # This file
└── ../
    ├── .config/git/config  # Delta and advanced Git settings
    ├── .config/lazygit/    # LazyGit configuration
    ├── .config/gh/         # GitHub CLI settings  
    └── .config/gitui/      # GitUI theme and keybindings
```

## 🛠️ Installation

### Quick Setup
```bash
# Run the automated setup
~/.dotfiles/git/setup.sh

# Or install individual components
~/.dotfiles/git/setup.sh install    # Install all tools
~/.dotfiles/git/setup.sh configure  # Configure only
~/.dotfiles/git/setup.sh verify     # Verify installation
~/.dotfiles/git/setup.sh auth       # Setup GitHub auth
```

### Manual Installation
```bash
# Install tools via Homebrew
brew install git git-delta lazygit gh gitui git-flow-avh git-extras

# Link configurations
ln -sf ~/.dotfiles/git/.gitconfig ~/.gitconfig
ln -sf ~/.dotfiles/.config/git/config ~/.config/git/config
ln -sf ~/.dotfiles/.config/lazygit/config.yml ~/.config/lazygit/config.yml
ln -sf ~/.dotfiles/.config/gh/config.yml ~/.config/gh/config.yml
ln -sf ~/.dotfiles/.config/gitui/theme.ron ~/.config/gitui/theme.ron
```

## 🎯 Quick Start

### Essential Commands
```bash
# Git TUI interfaces
lg                    # Launch LazyGit
gu                    # Launch GitUI

# Enhanced status and logs  
gss                   # Git status with emojis
gstat                 # Status with branch info
glog                  # Beautiful log with graph

# Quick commits
gct "message"         # Quick commit with timestamp
gcc feat "message"    # Conventional commit (feat/fix/docs/etc)
```

### Git Worktrees
```bash
# Create worktree for new feature
gwt feature-name      # Creates ../repo-feature-name

# List all worktrees  
gwt-list             # Show all worktrees with status

# Clean up worktree
gwt-rm feature-name   # Remove worktree and branch
```

### GitHub Integration
```bash
# Authentication
gh auth login         # Setup GitHub authentication

# Pull requests
gpr                   # Create pull request
gh pr status          # View PR status
gh pr view            # View current PR

# Issues
gh issue create       # Create new issue
gh issue list         # List issues
```

## 📋 Git Aliases Reference

### Basic Shortcuts
| Alias | Command | Description |
|-------|---------|-------------|
| `g` | `git` | Git shortcut |
| `gs` | `git status` | Status |
| `ga` | `git add` | Add files |
| `gc` | `git commit` | Commit |
| `gco` | `git checkout` | Checkout |
| `gb` | `git branch` | Branch operations |
| `gd` | `git diff` | Show diff |
| `gl` | `git log --oneline --graph` | Pretty log |
| `gp` | `git push` | Push changes |
| `gpl` | `git pull` | Pull changes |

### Advanced Functions
| Function | Description |
|----------|-------------|
| `gnb <name>` | Create and switch to new branch |
| `gclean` | Delete merged branches interactively |
| `gsync` | Sync branch with upstream |
| `gpff` | Safe force push with confirmation |
| `gri [n]` | Interactive rebase last n commits |
| `gsq <n>` | Squash last n commits |
| `galias` | Show all Git aliases |

### Worktree Management
| Function | Description |
|----------|-------------|
| `gwt <branch>` | Create new worktree |
| `gwt-list` | List all worktrees |
| `gwt-rm <branch>` | Remove worktree and branch |

### Conventional Commits
| Alias | Format |
|-------|--------|
| `gfeat` | `feat: message` |
| `gfix` | `fix: message` |
| `gdocs` | `docs: message` |
| `gstyle` | `style: message` |
| `grefactor` | `refactor: message` |
| `gperf` | `perf: message` |
| `gtest` | `test: message` |
| `gchore` | `chore: message` |

## ⚙️ Configuration Details

### Git Configuration Highlights
- **Performance**: Optimized for speed with parallel operations
- **Security**: SSH-first approach, signed commits support
- **Usability**: Enhanced colors, better diff algorithm
- **Integration**: Delta for diffs, GitHub CLI integration
- **Workflow**: Auto-rebase, force-with-lease, conflict resolution

### LazyGit Features
- **Theme**: Dracula theme with consistent colors
- **Keybindings**: Vim-like navigation
- **Custom Commands**: Conventional commits, GitHub integration
- **Workflows**: Branch management, interactive rebase

### Delta Configuration
- **Visual**: Side-by-side diffs with line numbers
- **Colors**: Dracula theme integration
- **Features**: Syntax highlighting, file navigation
- **Integration**: Works with all Git commands

## 🎨 Customization

### Personal Settings
Create `~/.gitconfig.local` for machine-specific settings:
```ini
[user]
    name = Your Name
    email = your.email@example.com
    signingkey = YOUR_GPG_KEY_ID

[commit]
    gpgsign = true
```

### Theme Customization
- **LazyGit**: Edit `~/.config/lazygit/config.yml`
- **GitUI**: Modify `~/.config/gitui/theme.ron`
- **Delta**: Adjust colors in `~/.config/git/config`

### Adding Custom Aliases
Add to `~/.dotfiles/zsh/aliases/git.sh`:
```bash
# Custom function
function my_git_function() {
    # Your custom logic here
}
alias mgf='my_git_function'
```

## 🔍 Troubleshooting

### Common Issues

**Delta not working:**
```bash
# Verify delta is installed and in PATH
delta --version

# Check Git configuration
git config core.pager
```

**LazyGit theme issues:**
```bash
# Verify config file location
ls ~/.config/lazygit/config.yml

# Test LazyGit
lazygit --version
```

**GitHub CLI authentication:**
```bash
# Check auth status
gh auth status

# Re-authenticate
gh auth login
```

### Reset Configuration
```bash
# Backup and reset
cp ~/.gitconfig ~/.gitconfig.backup
rm ~/.gitconfig
~/.dotfiles/git/setup.sh configure
```

## 📖 Resources

- [Git Documentation](https://git-scm.com/doc)
- [Delta GitHub](https://github.com/dandavison/delta)
- [LazyGit GitHub](https://github.com/jesseduffield/lazygit)
- [GitHub CLI Documentation](https://cli.github.com/manual/)
- [GitUI GitHub](https://github.com/extrawurst/gitui)
- [Conventional Commits](https://www.conventionalcommits.org/)

## 🤝 Contributing

Feel free to suggest improvements or add new aliases:
1. Fork the dotfiles repository
2. Make your changes
3. Test thoroughly
4. Submit a pull request

---

**Happy Git-ing! 🚀**