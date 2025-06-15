# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a personal dotfiles repository that uses GNU Stow for symlink management. Each tool's configuration is organized in its own directory following the structure it should have when deployed to the home directory.

## Common Commands

### System Setup
```bash
# Install all Homebrew packages and fonts
cd ~/.dotfiles/brew && ./install.sh

# Or just update packages from Brewfile
brew bundle --file=~/.dotfiles/brew/Brewfile
```

### Configuration Management
```bash
# Deploy a specific configuration
stow zsh      # Symlinks zsh config
stow tmux     # Symlinks tmux config
stow nvim     # Symlinks neovim config
stow aerospace # Symlinks aerospace config

# Remove a configuration
stow -D zsh

# Restow (useful after adding new files)
stow -R zsh
```

### Neovim Setup (after stowing nvim)
```bash
# First time setup - install plugins
nvim +PlugInstall +qa

# Update plugins
nvim +PlugUpdate +qa

# Clean unused plugins
nvim +PlugClean +qa
```

## Architecture

### Directory Structure
- Each top-level directory represents a "stowable" package
- Directory structure inside each package mirrors the target structure in `$HOME`
- Example: `zsh/.zshrc` gets symlinked to `~/.zshrc`

### Key Components

1. **Shell Configuration** (`zsh/`)
   - Modular alias system in `zsh/aliases/` with files dynamically sourced
   - Uses Oh My Zsh with Powerlevel10k theme
   - Custom shortcuts for navigation and common commands

2. **Package Management** (`brew/`)
   - Declarative package list in `Brewfile`
   - Installation script handles fonts separately

3. **Editor Configuration** (`nvim/`)
   - Lua-based Neovim configuration
   - Located in `.config/nvim/` following XDG conventions

4. **Window Management** (`aerospace/`)
   - Tiling window manager configuration
   - Works with `borders/` for window styling

### Configuration Patterns
- Aliases are split into logical files: `configs.sh` (config shortcuts), `dirs.sh` (navigation), `shorthand.sh` (command abbreviations)
- Cloud integration via iCloud paths for syncing certain files
- Plugin-based configurations for both zsh (Oh My Zsh) and tmux (TPM)