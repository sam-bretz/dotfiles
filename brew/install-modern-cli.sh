#!/usr/bin/env bash

# ============================================================================
# Modern CLI Tools Installation Script
# ============================================================================
# This script installs and configures modern CLI tools via Homebrew
# Author: dotfiles automation
# Usage: ./install-modern-cli.sh [--backup] [--force] [--dry-run]
# ============================================================================

set -euo pipefail

# Configuration
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly DOTFILES_ROOT="$(dirname "$SCRIPT_DIR")"
readonly BREWFILE="${SCRIPT_DIR}/Brewfile"
readonly LOG_FILE="${SCRIPT_DIR}/install.log"

# Colors for output
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly NC='\033[0m' # No Color

# Flags
BACKUP_MODE=false
FORCE_MODE=false
DRY_RUN=false

# ============================================================================
# Utility Functions
# ============================================================================

log() {
    echo -e "${GREEN}[$(date +'%Y-%m-%d %H:%M:%S')] $1${NC}" | tee -a "$LOG_FILE"
}

warn() {
    echo -e "${YELLOW}[WARN] $1${NC}" | tee -a "$LOG_FILE"
}

error() {
    echo -e "${RED}[ERROR] $1${NC}" | tee -a "$LOG_FILE" >&2
}

info() {
    echo -e "${BLUE}[INFO] $1${NC}" | tee -a "$LOG_FILE"
}

check_command() {
    if command -v "$1" >/dev/null 2>&1; then
        return 0
    else
        return 1
    fi
}

backup_existing_configs() {
    local backup_dir="${DOTFILES_ROOT}/backup/$(date +%Y%m%d_%H%M%S)"
    
    if [[ "$BACKUP_MODE" == true ]]; then
        log "Creating backup directory: $backup_dir"
        mkdir -p "$backup_dir"
        
        # Backup existing configurations
        local configs=(
            "$HOME/.config/zoxide"
            "$HOME/.config/atuin"
            "$HOME/.config/starship.toml"
            "$HOME/.config/yazi"
            "$HOME/.config/btop"
            "$HOME/.config/bottom"
            "$HOME/.config/broot"
        )
        
        for config in "${configs[@]}"; do
            if [[ -e "$config" ]]; then
                log "Backing up: $config"
                cp -r "$config" "$backup_dir/"
            fi
        done
    fi
}

# ============================================================================
# Pre-installation Checks
# ============================================================================

check_prerequisites() {
    info "Checking prerequisites..."
    
    # Check if running on macOS
    if [[ "$(uname)" != "Darwin" ]]; then
        error "This script is designed for macOS only"
        exit 1
    fi
    
    # Check if Homebrew is installed
    if ! check_command brew; then
        error "Homebrew is not installed. Please install it first:"
        error "  /bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
        exit 1
    fi
    
    # Check if Brewfile exists
    if [[ ! -f "$BREWFILE" ]]; then
        error "Brewfile not found at: $BREWFILE"
        exit 1
    fi
    
    info "Prerequisites check passed"
}

# ============================================================================
# Installation Functions
# ============================================================================

install_brew_packages() {
    info "Installing packages from Brewfile..."
    
    if [[ "$DRY_RUN" == true ]]; then
        info "[DRY RUN] Would install packages from: $BREWFILE"
        brew bundle --file="$BREWFILE" --verbose --dry-run
        return
    fi
    
    # Update Homebrew first
    log "Updating Homebrew..."
    brew update
    
    # Install packages
    log "Installing packages..."
    if brew bundle --file="$BREWFILE" --verbose; then
        log "Successfully installed packages from Brewfile"
    else
        error "Failed to install some packages. Check the log for details."
        return 1
    fi
}

configure_zoxide() {
    log "Configuring zoxide..."
    
    if check_command zoxide; then
        # zoxide doesn't need additional config files, just shell integration
        log "zoxide installed successfully - shell integration will be added to zsh config"
    else
        warn "zoxide not found, skipping configuration"
    fi
}

configure_atuin() {
    log "Configuring atuin..."
    
    if check_command atuin; then
        local atuin_config="$HOME/.config/atuin"
        mkdir -p "$atuin_config"
        
        # Only create config if it doesn't exist
        if [[ ! -f "${atuin_config}/config.toml" ]]; then
            cat > "${atuin_config}/config.toml" << 'EOF'
## Atuin Configuration
# See: https://atuin.sh/docs/config/

# Data directory
data_dir = "~/.local/share/atuin"

# Sync configuration
auto_sync = true
sync_frequency = "1h"
sync_address = "https://api.atuin.sh"

# Search configuration
search_mode = "fuzzy"
filter_mode = "global"
style = "compact"
show_preview = true
max_preview_height = 4

# History configuration
history_format = "{time} · {command}"
inline_height = 40

# Key bindings
keymap_mode = "emacs"

# Statistics
common_prefix = ["sudo"]
common_subcommands = ["git", "cargo", "npm", "yarn"]
EOF
            log "Created atuin config at: ${atuin_config}/config.toml"
        else
            info "atuin config already exists, skipping"
        fi
    else
        warn "atuin not found, skipping configuration"
    fi
}

configure_starship() {
    log "Configuring starship..."
    
    if check_command starship; then
        local starship_config="$HOME/.config/starship.toml"
        
        # Only create config if it doesn't exist
        if [[ ! -f "$starship_config" ]]; then
            cat > "$starship_config" << 'EOF'
# Starship Configuration
# See: https://starship.rs/config/

format = """
$username\
$hostname\
$directory\
$git_branch\
$git_state\
$git_status\
$cmd_duration\
$line_break\
$python\
$character"""

# Prompt character
[character]
success_symbol = "[❯](bold green)"
error_symbol = "[❯](bold red)"

# Directory
[directory]
style = "blue"
truncation_length = 3
truncate_to_repo = true

# Git branch
[git_branch]
symbol = "🌱 "
style = "bold yellow"

# Git status
[git_status]
format = '[\($all_status$ahead_behind\)]($style) '
style = "bold green"
conflicted = "🏳"
up_to_date = "✓"
untracked = "🤷"
ahead = "⇡${count}"
diverged = "⇕⇡${ahead_count}⇣${behind_count}"
behind = "⇣${count}"
stashed = "📦"
modified = "📝"
staged = '[++\($count\)](green)'
renamed = "👅"
deleted = "🗑"

# Command duration
[cmd_duration]
format = "underwent [$duration](bold yellow)"
show_milliseconds = true
min_time = 500

# Python
[python]
symbol = "🐍 "
pyenv_version_name = true
EOF
            log "Created starship config at: $starship_config"
        else
            info "starship config already exists, skipping"
        fi
    else
        warn "starship not found, skipping configuration"
    fi
}

configure_btop() {
    log "Configuring btop..."
    
    if check_command btop; then
        local btop_config="$HOME/.config/btop"
        mkdir -p "$btop_config"
        
        # Only create config if it doesn't exist
        if [[ ! -f "${btop_config}/btop.conf" ]]; then
            cat > "${btop_config}/btop.conf" << 'EOF'
#? Config file for btop v. 1.2.13

#* Color theme
color_theme = "dracula"

#* If the theme set background should be shown, set to False if you want terminal background transparency.
theme_background = True

#* Sets if 24-bit truecolor should be used, will convert 24-bit colors to 256 color (6x6x6 color cube) if false.
truecolor = True

#* Show graph update rate in top-right corner
show_update_ms = True

#* Update time in milliseconds, recommended 2000 ms or above for better sample times for graphs.
update_ms = 2000

#* Show battery stats in top-right corner if battery is found
show_battery = True

#* Show cpu temperature
show_coretemp = True

#* Check for a new version from github.com/aristocratos/btop at start.
check_update = True
EOF
            log "Created btop config at: ${btop_config}/btop.conf"
        else
            info "btop config already exists, skipping"
        fi
    else
        warn "btop not found, skipping configuration"
    fi
}

# ============================================================================
# Main Installation Flow
# ============================================================================

parse_arguments() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            --backup)
                BACKUP_MODE=true
                shift
                ;;
            --force)
                FORCE_MODE=true
                shift
                ;;
            --dry-run)
                DRY_RUN=true
                shift
                ;;
            -h|--help)
                echo "Usage: $0 [--backup] [--force] [--dry-run]"
                echo ""
                echo "Options:"
                echo "  --backup    Create backup of existing configurations"
                echo "  --force     Force installation even if tools are already installed"
                echo "  --dry-run   Show what would be installed without making changes"
                echo "  -h, --help  Show this help message"
                exit 0
                ;;
            *)
                error "Unknown option: $1"
                exit 1
                ;;
        esac
    done
}

main() {
    parse_arguments "$@"
    
    # Initialize log file
    echo "Modern CLI Tools Installation Log - $(date)" > "$LOG_FILE"
    
    log "Starting modern CLI tools installation..."
    log "Script directory: $SCRIPT_DIR"
    log "Dotfiles root: $DOTFILES_ROOT"
    log "Backup mode: $BACKUP_MODE"
    log "Force mode: $FORCE_MODE"
    log "Dry run: $DRY_RUN"
    
    # Run pre-checks
    check_prerequisites
    
    # Backup existing configs if requested
    if [[ "$BACKUP_MODE" == true ]]; then
        backup_existing_configs
    fi
    
    # Install packages
    install_brew_packages
    
    # Configure tools (skip in dry-run mode)
    if [[ "$DRY_RUN" != true ]]; then
        configure_zoxide
        configure_atuin
        configure_starship
        configure_btop
    fi
    
    log "Installation completed successfully!"
    
    if [[ "$DRY_RUN" != true ]]; then
        echo ""
        info "Next steps:"
        info "1. Restart your terminal or source your shell configuration"
        info "2. Run 'atuin register' to set up shell history sync (optional)"
        info "3. Run 'zoxide --help' to learn about the new cd replacement"
        info "4. Check the log file for details: $LOG_FILE"
    fi
}

# Run the main function with all passed arguments
main "$@"