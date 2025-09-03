#!/usr/bin/env bash

# ============================================================================
# Modern CLI Tools Setup Script
# ============================================================================
# Complete setup for modern CLI tools including installation, configuration,
# and integration with existing dotfiles structure
# ============================================================================

set -euo pipefail

# Configuration
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly DOTFILES_ROOT="$SCRIPT_DIR"
readonly CONFIG_DIR="$HOME/.config"
readonly BACKUP_DIR="$DOTFILES_ROOT/backup/$(date +%Y%m%d_%H%M%S)"
readonly LOG_FILE="$DOTFILES_ROOT/setup-modern-cli.log"

# Colors
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly NC='\033[0m'

# Flags
BACKUP_EXISTING=true
INSTALL_TOOLS=true
SETUP_CONFIGS=true
DRY_RUN=false
FORCE_OVERWRITE=false

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
    command -v "$1" >/dev/null 2>&1
}

create_symlink() {
    local source="$1"
    local target="$2"
    
    if [[ "$DRY_RUN" == true ]]; then
        info "[DRY RUN] Would create symlink: $target -> $source"
        return 0
    fi
    
    # Create parent directory if needed
    local parent_dir
    parent_dir="$(dirname "$target")"
    mkdir -p "$parent_dir"
    
    # Handle existing files/links
    if [[ -e "$target" ]] || [[ -L "$target" ]]; then
        if [[ "$BACKUP_EXISTING" == true ]]; then
            local backup_path="$BACKUP_DIR/$(basename "$target")"
            mkdir -p "$BACKUP_DIR"
            mv "$target" "$backup_path"
            log "Backed up existing file: $target -> $backup_path"
        elif [[ "$FORCE_OVERWRITE" == true ]]; then
            rm -rf "$target"
            log "Removed existing file: $target"
        else
            warn "Target already exists: $target (use --force or --backup)"
            return 1
        fi
    fi
    
    # Create the symlink
    ln -sf "$source" "$target"
    log "Created symlink: $target -> $source"
}

# ============================================================================
# Installation Functions
# ============================================================================

install_homebrew_packages() {
    if [[ "$INSTALL_TOOLS" != true ]]; then
        info "Skipping tool installation (use --install to enable)"
        return 0
    fi
    
    log "Installing modern CLI tools via Homebrew..."
    
    if [[ "$DRY_RUN" == true ]]; then
        info "[DRY RUN] Would run: $DOTFILES_ROOT/brew/install-modern-cli.sh"
        return 0
    fi
    
    if [[ -x "$DOTFILES_ROOT/brew/install-modern-cli.sh" ]]; then
        "$DOTFILES_ROOT/brew/install-modern-cli.sh" --backup
    else
        error "Installation script not found or not executable"
        return 1
    fi
}

# ============================================================================
# Configuration Setup Functions
# ============================================================================

setup_starship_config() {
    local source="$DOTFILES_ROOT/configs/starship/starship.toml"
    local target="$CONFIG_DIR/starship.toml"
    
    if [[ -f "$source" ]]; then
        create_symlink "$source" "$target"
    else
        warn "Starship config not found: $source"
    fi
}

setup_atuin_config() {
    local source="$DOTFILES_ROOT/configs/atuin/config.toml"
    local target="$CONFIG_DIR/atuin/config.toml"
    
    if [[ -f "$source" ]]; then
        create_symlink "$source" "$target"
    else
        warn "Atuin config not found: $source"
    fi
}

setup_yazi_config() {
    local source="$DOTFILES_ROOT/configs/yazi/yazi.toml"
    local target="$CONFIG_DIR/yazi/yazi.toml"
    
    if [[ -f "$source" ]]; then
        create_symlink "$source" "$target"
    else
        warn "Yazi config not found: $source"
    fi
}

setup_btop_config() {
    local source="$DOTFILES_ROOT/configs/btop/btop.conf"
    local target="$CONFIG_DIR/btop/btop.conf"
    
    if [[ -f "$source" ]]; then
        create_symlink "$source" "$target"
    else
        warn "Btop config not found: $source"
    fi
}

setup_broot_config() {
    local source="$DOTFILES_ROOT/configs/broot/config.hjson"
    local target="$CONFIG_DIR/broot/conf.hjson"
    
    if [[ -f "$source" ]]; then
        create_symlink "$source" "$target"
        
        # Initialize broot to create launcher
        if check_command broot && [[ "$DRY_RUN" != true ]]; then
            info "Initializing broot..."
            echo "y" | broot --install >/dev/null 2>&1 || true
        fi
    else
        warn "Broot config not found: $source"
    fi
}

setup_git_config() {
    if check_command delta; then
        log "Configuring git to use delta..."
        
        if [[ "$DRY_RUN" != true ]]; then
            git config --global core.pager delta
            git config --global interactive.diffFilter 'delta --color-only'
            git config --global delta.navigate true
            git config --global delta.light false
            git config --global merge.conflictstyle diff3
        fi
    fi
}

# ============================================================================
# Verification Functions
# ============================================================================

verify_installation() {
    log "Verifying installation..."
    
    local tools=(
        "eza:Enhanced ls"
        "bat:Enhanced cat"
        "fd:Enhanced find"
        "rg:Enhanced grep"
        "zoxide:Smart cd"
        "atuin:Smart history"
        "dust:Enhanced du"
        "btop:Enhanced top"
        "yazi:Terminal file manager"
        "starship:Modern prompt"
        "lazygit:Git TUI"
        "delta:Git diff viewer"
    )
    
    local installed_count=0
    local total_count=${#tools[@]}
    
    echo ""
    info "Tool verification report:"
    
    for tool_info in "${tools[@]}"; do
        local tool="${tool_info%:*}"
        local desc="${tool_info#*:}"
        
        if check_command "$tool"; then
            echo "  ✅ $tool - $desc"
            ((installed_count++))
        else
            echo "  ❌ $tool - $desc"
        fi
    done
    
    echo ""
    info "Installed: $installed_count/$total_count tools"
    
    # Verify configurations
    echo ""
    info "Configuration verification:"
    
    local configs=(
        "$CONFIG_DIR/starship.toml:Starship"
        "$CONFIG_DIR/atuin/config.toml:Atuin"
        "$CONFIG_DIR/yazi/yazi.toml:Yazi"
        "$CONFIG_DIR/btop/btop.conf:Btop"
        "$CONFIG_DIR/broot/conf.hjson:Broot"
    )
    
    for config_info in "${configs[@]}"; do
        local config_path="${config_info%:*}"
        local config_name="${config_info#*:}"
        
        if [[ -f "$config_path" ]]; then
            echo "  ✅ $config_name config: $config_path"
        else
            echo "  ❌ $config_name config: $config_path"
        fi
    done
}

# ============================================================================
# Backup and Restore Functions
# ============================================================================

create_backup() {
    if [[ "$BACKUP_EXISTING" != true ]]; then
        return 0
    fi
    
    log "Creating backup of existing configurations..."
    mkdir -p "$BACKUP_DIR"
    
    local items_to_backup=(
        "$CONFIG_DIR/starship.toml"
        "$CONFIG_DIR/atuin"
        "$CONFIG_DIR/yazi"
        "$CONFIG_DIR/btop"
        "$CONFIG_DIR/broot"
        "$HOME/.zshrc.backup-$(date +%Y%m%d)"
    )
    
    for item in "${items_to_backup[@]}"; do
        if [[ -e "$item" ]]; then
            local backup_name
            backup_name="$(basename "$item")"
            cp -r "$item" "$BACKUP_DIR/$backup_name"
            log "Backed up: $item"
        fi
    done
    
    info "Backup created at: $BACKUP_DIR"
}

restore_backup() {
    local backup_date="$1"
    local restore_dir="$DOTFILES_ROOT/backup/$backup_date"
    
    if [[ ! -d "$restore_dir" ]]; then
        error "Backup directory not found: $restore_dir"
        return 1
    fi
    
    log "Restoring backup from: $restore_dir"
    
    # This would implement restore logic
    # For now, just show what would be restored
    info "Available backups in $restore_dir:"
    ls -la "$restore_dir"
}

# ============================================================================
# Main Setup Functions
# ============================================================================

setup_all_configs() {
    if [[ "$SETUP_CONFIGS" != true ]]; then
        info "Skipping configuration setup (use --config to enable)"
        return 0
    fi
    
    log "Setting up configurations..."
    
    setup_starship_config
    setup_atuin_config
    setup_yazi_config
    setup_btop_config
    setup_broot_config
    setup_git_config
    
    log "Configuration setup completed"
}

show_next_steps() {
    cat << 'EOF'

🎉 Modern CLI Tools Setup Complete!

📋 Next Steps:

1. 🔄 Restart your terminal or run: source ~/.zshrc

2. 🚀 Quick Start Commands:
   • check-modern-tools  → Check installation status
   • modern-help         → View quick reference
   • z <directory>       → Smart directory jumping
   • Ctrl+R             → Smart history search

3. ⚙️  Configuration Options:
   • Set PREFER_STARSHIP=true in ~/.zshrc to use Starship over Powerlevel10k
   • Run 'atuin register' to sync history across machines
   • Customize configs in ~/.config/

4. 📚 Learn More:
   • ls                 → Enhanced with colors and git status
   • cat file.txt       → Syntax highlighted viewing
   • find . -name "*.py" → Fast file search
   • top               → Beautiful system monitor

5. 🔧 Troubleshooting:
   • Check log file: ~/.dotfiles/setup-modern-cli.log
   • Verify tools: check-modern-tools
   • Restore backup if needed

EOF
}

# ============================================================================
# Command Line Interface
# ============================================================================

show_help() {
    cat << 'EOF'
Modern CLI Tools Setup Script

USAGE:
    ./setup-modern-cli.sh [OPTIONS]

OPTIONS:
    --install           Install tools via Homebrew (default: true)
    --no-install        Skip tool installation
    --config            Setup configurations (default: true)
    --no-config         Skip configuration setup
    --backup            Backup existing configs (default: true)
    --no-backup         Don't backup existing configs
    --force             Force overwrite existing configs
    --dry-run           Show what would be done without making changes
    --restore DATE      Restore from backup (format: YYYYMMDD_HHMMSS)
    --verify            Only verify installation status
    -h, --help          Show this help message

EXAMPLES:
    ./setup-modern-cli.sh                    # Full setup with backups
    ./setup-modern-cli.sh --dry-run          # Preview changes
    ./setup-modern-cli.sh --no-install       # Only setup configs
    ./setup-modern-cli.sh --verify           # Check installation status
    ./setup-modern-cli.sh --restore 20240130_120000

EOF
}

parse_arguments() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            --install)
                INSTALL_TOOLS=true
                shift
                ;;
            --no-install)
                INSTALL_TOOLS=false
                shift
                ;;
            --config)
                SETUP_CONFIGS=true
                shift
                ;;
            --no-config)
                SETUP_CONFIGS=false
                shift
                ;;
            --backup)
                BACKUP_EXISTING=true
                shift
                ;;
            --no-backup)
                BACKUP_EXISTING=false
                shift
                ;;
            --force)
                FORCE_OVERWRITE=true
                shift
                ;;
            --dry-run)
                DRY_RUN=true
                shift
                ;;
            --restore)
                restore_backup "$2"
                exit 0
                ;;
            --verify)
                verify_installation
                exit 0
                ;;
            -h|--help)
                show_help
                exit 0
                ;;
            *)
                error "Unknown option: $1"
                show_help
                exit 1
                ;;
        esac
    done
}

main() {
    parse_arguments "$@"
    
    # Initialize log
    echo "Modern CLI Tools Setup - $(date)" > "$LOG_FILE"
    
    log "Starting modern CLI tools setup..."
    log "Dotfiles root: $DOTFILES_ROOT"
    log "Config directory: $CONFIG_DIR"
    log "Install tools: $INSTALL_TOOLS"
    log "Setup configs: $SETUP_CONFIGS"
    log "Backup existing: $BACKUP_EXISTING"
    log "Dry run: $DRY_RUN"
    
    # Create backup if needed
    if [[ "$BACKUP_EXISTING" == true ]] && [[ "$DRY_RUN" != true ]]; then
        create_backup
    fi
    
    # Install tools
    install_homebrew_packages
    
    # Setup configurations
    setup_all_configs
    
    # Verify installation
    verify_installation
    
    # Show next steps
    if [[ "$DRY_RUN" != true ]]; then
        show_next_steps
    fi
    
    log "Setup completed successfully!"
    info "Log file: $LOG_FILE"
}

# Run main function
main "$@"