#!/usr/bin/env bash
# ============================================================================
# Git Tools Setup Script
# Enhanced Git workflow with modern tools
# ============================================================================

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Emoji support
CHECKMARK="✅"
CROSS="❌"
INFO="ℹ️"
ROCKET="🚀"
GEAR="⚙️"
PACKAGE="📦"

log_info() {
    echo -e "${CYAN}${INFO} $1${NC}"
}

log_success() {
    echo -e "${GREEN}${CHECKMARK} $1${NC}"
}

log_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

log_error() {
    echo -e "${RED}${CROSS} $1${NC}"
}

log_header() {
    echo -e "\n${PURPLE}${ROCKET} $1${NC}"
}

# Check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Install with Homebrew
brew_install() {
    local package="$1"
    local name="${2:-$package}"
    
    if command_exists "$name"; then
        log_success "$name is already installed"
        return 0
    fi
    
    log_info "Installing $name..."
    if brew install "$package"; then
        log_success "$name installed successfully"
    else
        log_error "Failed to install $name"
        return 1
    fi
}

# Install with Homebrew cask
brew_cask_install() {
    local package="$1"
    local name="${2:-$package}"
    
    if brew list --cask "$package" >/dev/null 2>&1; then
        log_success "$name is already installed"
        return 0
    fi
    
    log_info "Installing $name..."
    if brew install --cask "$package"; then
        log_success "$name installed successfully"
    else
        log_error "Failed to install $name"
        return 1
    fi
}

# Main installation function
install_git_tools() {
    log_header "Installing Enhanced Git Tools"
    
    # Check if Homebrew is installed
    if ! command_exists brew; then
        log_error "Homebrew is required but not installed. Please install it first:"
        echo "  /bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
        exit 1
    fi
    
    # Update Homebrew
    log_info "Updating Homebrew..."
    brew update
    
    # Install Git (latest version)
    log_header "Git Configuration"
    brew_install git
    
    # Install delta for better diffs
    log_header "Delta - Better Git Diffs"
    brew_install git-delta delta
    
    # Install lazygit
    log_header "LazyGit - Git TUI"
    brew_install lazygit
    
    # Install GitHub CLI
    log_header "GitHub CLI"
    brew_install gh
    
    # Install GitUI (alternative TUI)
    log_header "GitUI - Alternative Git TUI"
    brew_install gitui
    
    # Install additional Git tools
    log_header "Additional Git Tools"
    brew_install git-flow-avh git-flow
    brew_install git-extras
    brew_install diff-so-fancy
    
    # Optional GUI tools
    log_header "Optional GUI Tools"
    echo "The following GUI tools are available but not auto-installed:"
    echo "  - Sourcetree: brew install --cask sourcetree"
    echo "  - GitKraken: brew install --cask gitkraken"
    echo "  - Tower: brew install --cask tower"
    echo "  - Sublime Merge: brew install --cask sublime-merge"
    
    log_success "All Git tools installed successfully!"
}

# Configure Git
configure_git() {
    log_header "Configuring Git"
    
    # Backup existing git config
    if [[ -f ~/.gitconfig ]]; then
        log_info "Backing up existing .gitconfig..."
        cp ~/.gitconfig ~/.gitconfig.backup.$(date +%Y%m%d-%H%M%S)
        log_success "Backup created"
    fi
    
    # Link the new git configuration
    local dotfiles_git_config="$HOME/.dotfiles/git/.gitconfig"
    if [[ -f "$dotfiles_git_config" ]]; then
        log_info "Linking Git configuration..."
        ln -sf "$dotfiles_git_config" ~/.gitconfig
        log_success "Git configuration linked"
    else
        log_error "Git configuration not found at $dotfiles_git_config"
        return 1
    fi
    
    # Ensure config directories exist
    mkdir -p ~/.config/git
    mkdir -p ~/.config/lazygit
    mkdir -p ~/.config/gh
    mkdir -p ~/.config/gitui
    
    # Link additional configurations
    local dotfiles_dir="$HOME/.dotfiles/.config"
    
    # Link git config
    if [[ -f "$dotfiles_dir/git/config" ]]; then
        ln -sf "$dotfiles_dir/git/config" ~/.config/git/config
        log_success "Delta configuration linked"
    fi
    
    # Link lazygit config
    if [[ -f "$dotfiles_dir/lazygit/config.yml" ]]; then
        ln -sf "$dotfiles_dir/lazygit/config.yml" ~/.config/lazygit/config.yml
        log_success "LazyGit configuration linked"
    fi
    
    # Link gh config
    if [[ -f "$dotfiles_dir/gh/config.yml" ]]; then
        ln -sf "$dotfiles_dir/gh/config.yml" ~/.config/gh/config.yml
        log_success "GitHub CLI configuration linked"
    fi
    
    # Link gitui config
    if [[ -f "$dotfiles_dir/gitui/theme.ron" ]]; then
        ln -sf "$dotfiles_dir/gitui/theme.ron" ~/.config/gitui/theme.ron
        log_success "GitUI theme linked"
    fi
    
    if [[ -f "$dotfiles_dir/gitui/key_bindings.ron" ]]; then
        ln -sf "$dotfiles_dir/gitui/key_bindings.ron" ~/.config/gitui/key_bindings.ron
        log_success "GitUI key bindings linked"
    fi
}

# Verify installation
verify_installation() {
    log_header "Verifying Installation"
    
    local tools=("git" "delta" "lazygit" "gh" "gitui")
    local all_good=true
    
    for tool in "${tools[@]}"; do
        if command_exists "$tool"; then
            local version
            case "$tool" in
                "git") version=$(git --version | head -n1) ;;
                "delta") version=$(delta --version | head -n1) ;;
                "lazygit") version=$(lazygit --version | head -n1) ;;
                "gh") version=$(gh --version | head -n1) ;;
                "gitui") version=$(gitui --version | head -n1) ;;
            esac
            log_success "$tool: $version"
        else
            log_error "$tool: Not found"
            all_good=false
        fi
    done
    
    if $all_good; then
        log_success "All tools verified successfully!"
    else
        log_error "Some tools are missing. Please check the installation."
        return 1
    fi
}

# Setup GitHub authentication
setup_github_auth() {
    log_header "GitHub Authentication Setup"
    
    if command_exists gh; then
        if gh auth status >/dev/null 2>&1; then
            log_success "GitHub authentication is already configured"
            gh auth status
        else
            log_info "Setting up GitHub authentication..."
            echo "Please run: gh auth login"
            echo "This will authenticate with GitHub and set up SSH keys."
        fi
    else
        log_warning "GitHub CLI not installed, skipping authentication setup"
    fi
}

# Show usage information
show_usage() {
    log_header "Enhanced Git Workflow - Usage Guide"
    
    cat << 'EOF'
🚀 Your enhanced Git workflow is ready!

Key Tools Installed:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📊 LazyGit (lg)          - Modern Git TUI with branch management
🎨 GitUI (gu)            - Fast terminal Git UI written in Rust  
📐 Delta                 - Enhanced diff viewer with syntax highlighting
🐙 GitHub CLI (gh)       - GitHub integration from command line
⚡ Git Aliases          - 50+ productivity shortcuts

Quick Start:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

• lg                     - Launch LazyGit
• gu                     - Launch GitUI  
• git-help               - Show all custom Git aliases
• gh auth login          - Authenticate with GitHub
• gss                    - Enhanced Git status with emojis

Advanced Features:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

• gwt <branch>           - Create Git worktree  
• gclean                 - Clean merged branches
• gcc feat "message"     - Conventional commits
• gpff                   - Safe force push
• gsync                  - Sync with upstream

GitHub Integration:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

• gpr                    - Create pull request
• gh pr status           - View PR status  
• gh issue create        - Create GitHub issue
• gh repo view           - View repository info

Configuration Files:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

• ~/.gitconfig           - Main Git configuration with 50+ aliases
• ~/.config/git/config   - Delta and advanced Git settings
• ~/.config/lazygit/     - LazyGit theme and keybindings  
• ~/.config/gh/          - GitHub CLI configuration
• ~/.config/gitui/       - GitUI theme and keybindings

Next Steps:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

1. Run 'gh auth login' to authenticate with GitHub
2. Try 'lg' or 'gu' to explore the Git TUIs
3. Use 'git-help' to see all available aliases
4. Customize themes and settings as needed

Happy coding! 🎉
EOF
}

# Main execution
main() {
    echo -e "${BLUE}"
    cat << 'EOF'
╭─────────────────────────────────────────────────────────────╮
│                                                             │
│     🚀 Enhanced Git Workflow Setup                         │
│     Modern tools for productive Git development            │
│                                                             │
╰─────────────────────────────────────────────────────────────╯
EOF
    echo -e "${NC}"
    
    # Parse command line arguments
    case "${1:-install}" in
        "install")
            install_git_tools
            configure_git
            verify_installation
            setup_github_auth
            show_usage
            ;;
        "configure")
            configure_git
            ;;
        "verify")
            verify_installation
            ;;
        "auth")
            setup_github_auth
            ;;
        "help"|"-h"|"--help")
            show_usage
            ;;
        *)
            log_error "Unknown command: $1"
            echo "Usage: $0 [install|configure|verify|auth|help]"
            exit 1
            ;;
    esac
    
    log_success "Setup complete! 🎉"
}

# Run main function with all arguments
main "$@"