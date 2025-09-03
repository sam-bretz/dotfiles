# Dotfiles Enhancement Plan

## Overview
This plan outlines a systematic approach to modernizing and improving the dotfiles configuration. Each phase builds upon the previous one, ensuring stability and compatibility.

## Phase 1: Foundation & Security (Priority: HIGH)
### 1.1 Security Improvements
- [ ] Remove hardcoded password from `zsh/aliases/dirs.sh` line 15
- [ ] Setup 1Password CLI integration for secrets
- [ ] Create `.env.example` template for sensitive variables
- [ ] Add age encryption for sensitive configs

### 1.2 Tmux Core Enhancements
- [ ] Add tmux-yank plugin for clipboard integration
- [ ] Add tmux-fzf for fuzzy finding
- [ ] Add tmux-thumbs for quick text copying
- [ ] Configure continuum auto-boot: `set -g @continuum-boot 'on'`
- [ ] Add session management keybindings

## Phase 2: Shell & Terminal (Priority: HIGH)
### 2.1 Zsh Configuration
- [ ] Add history optimizations (HIST_IGNORE_SPACE, SHARE_HISTORY, HIST_VERIFY)
- [ ] Configure directory navigation (AUTO_PUSHD, PUSHD_IGNORE_DUPS)
- [ ] Install zsh-completions package
- [ ] Add kubectl plugin to oh-my-zsh

### 2.2 FZF Integration
- [ ] Install fzf via homebrew
- [ ] Add fzf-tab plugin for tab completion
- [ ] Install forgit for interactive git
- [ ] Configure FZF_DEFAULT_OPTS for better UI

### 2.3 Modern CLI Tools
- [ ] Install and configure zoxide (smart cd)
- [ ] Install atuin for shell history sync
- [ ] Install eza (modern ls)
- [ ] Install bat (better cat)
- [ ] Install btop (system monitor)
- [ ] Install dust (disk usage)
- [ ] Install procs (modern ps)
- [ ] Install yazi (file manager)

## Phase 3: Development Workflow (Priority: MEDIUM)
### 3.1 Git Enhancements
- [ ] Install lazygit for interactive git UI
- [ ] Install delta for better diffs
- [ ] Install gh CLI for GitHub operations
- [ ] Create dedicated git.sh aliases file

### 3.2 Runtime Management
- [ ] Install mise (formerly rtx) for version management
- [ ] Install direnv for project environments
- [ ] Configure auto-switching for Node/Python/Go versions

### 3.3 Neovim Improvements
- [ ] Add oil.nvim for file editing as buffers
- [ ] Add flash.nvim or leap.nvim for better motion
- [ ] Verify conform.nvim setup for formatting
- [ ] Add additional LSP servers as needed

## Phase 4: Organization & Structure (Priority: MEDIUM)
### 4.1 Alias Organization
- [ ] Create `zsh/aliases/git.sh` for git aliases
- [ ] Create `zsh/aliases/docker.sh` for container operations
- [ ] Create `zsh/aliases/npm.sh` for Node.js shortcuts
- [ ] Create `zsh/aliases/utils.sh` for general utilities
- [ ] Refactor existing aliases into appropriate files

### 4.2 Stow Improvements
- [ ] Add `.stow-local-ignore` files
- [ ] Create `install.sh` script for automated setup
- [ ] Document stow usage in README

### 4.3 AeroSpace Enhancements
- [ ] Add workspace-specific app assignments
- [ ] Configure app-to-workspace rules
- [ ] Add more service mode commands

## Phase 5: Optional Enhancements (Priority: LOW)
### 5.1 Alternative Tools
- [ ] Evaluate Zellij as tmux alternative
- [ ] Consider starship prompt vs powerlevel10k
- [ ] Test WezTerm as Alacritty alternative

### 5.2 Additional Configurations
- [ ] Setup sketchybar properly
- [ ] Configure borders tool
- [ ] Add Brewfile for dependency management

## Implementation Order
1. **Week 1**: Phase 1 (Security & Tmux)
2. **Week 2**: Phase 2.1-2.2 (Zsh & FZF)
3. **Week 3**: Phase 2.3 (Modern CLI Tools)
4. **Week 4**: Phase 3 (Development Workflow)
5. **Week 5**: Phase 4 (Organization)
6. **As needed**: Phase 5 (Optional)

## Testing Strategy
- Test each change in isolation
- Backup existing configs before modifications
- Use git branches for major changes
- Document breaking changes

## Rollback Plan
- Keep original configs in `.backup/` directory
- Use git for version control
- Test in fresh terminal session before committing
- Document any compatibility issues

## Success Metrics
- Reduced keystrokes for common operations
- Faster file navigation and search
- Improved git workflow efficiency
- Better organization and maintainability
- Enhanced security for sensitive data

## Notes
- All installations should be done via Homebrew when possible
- Maintain compatibility with both macOS and Linux
- Document all custom keybindings
- Keep configurations minimal and purposeful