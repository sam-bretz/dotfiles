#!/usr/bin/env bash
# ============================================================================
# Git Configuration Verification Script
# ============================================================================

set -euo pipefail

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Emojis
CHECK="✅"
CROSS="❌"
INFO="ℹ️"
ROCKET="🚀"

log_info() { echo -e "${BLUE}${INFO} $1${NC}"; }
log_success() { echo -e "${GREEN}${CHECK} $1${NC}"; }
log_warning() { echo -e "${YELLOW}⚠️  $1${NC}"; }
log_error() { echo -e "${RED}${CROSS} $1${NC}"; }
log_header() { echo -e "\n${BLUE}${ROCKET} $1${NC}"; }

# Check if file exists and is readable
check_file() {
    local file="$1"
    local desc="$2"
    
    if [[ -f "$file" && -r "$file" ]]; then
        log_success "$desc: $file"
        return 0
    else
        log_error "$desc: $file (missing or unreadable)"
        return 1
    fi
}

# Check if command exists
check_command() {
    local cmd="$1"
    local desc="$2"
    
    if command -v "$cmd" >/dev/null 2>&1; then
        local version
        case "$cmd" in
            "git") version=$(git --version) ;;
            "delta") version=$(delta --version | head -n1) ;;
            "lazygit") version=$(lazygit --version 2>/dev/null | head -n1) ;;
            "gh") version=$(gh --version | head -n1) ;;
            "gitui") version=$(gitui --version | head -n1) ;;
            *) version="available" ;;
        esac
        log_success "$desc: $version"
        return 0
    else
        log_error "$desc: Not found"
        return 1
    fi
}

# Test Git alias functionality
test_git_aliases() {
    log_header "Testing Git Aliases"
    
    # Test basic aliases
    if git config --get alias.st >/dev/null 2>&1; then
        log_success "Git aliases configured"
    else
        log_error "Git aliases not found"
        return 1
    fi
    
    # Test worktree aliases
    if git config --get alias.spawn >/dev/null 2>&1; then
        log_success "Worktree aliases configured"
    else
        log_error "Worktree aliases not found"
        return 1
    fi
    
    # Test delta configuration
    if git config --get core.pager | grep -q delta; then
        log_success "Delta configured as pager"
    else
        log_warning "Delta not configured as pager"
    fi
}

# Test shell aliases
test_shell_aliases() {
    log_header "Testing Shell Aliases"
    
    # Source the git aliases file
    local git_aliases_file="$HOME/.dotfiles/zsh/aliases/git.sh"
    
    if [[ -f "$git_aliases_file" ]]; then
        if source "$git_aliases_file" 2>/dev/null; then
            log_success "Git shell aliases loaded successfully"
            
            # Test specific functions exist
            if declare -f gss >/dev/null 2>&1; then
                log_success "Function 'gss' available"
            else
                log_error "Function 'gss' not found"
            fi
            
            if declare -f gwt >/dev/null 2>&1; then
                log_success "Function 'gwt' available"  
            else
                log_error "Function 'gwt' not found"
            fi
        else
            log_error "Failed to source git aliases"
            return 1
        fi
    else
        log_error "Git aliases file not found: $git_aliases_file"
        return 1
    fi
}

# Main verification function
main() {
    echo -e "${BLUE}"
    cat << 'EOF'
╭─────────────────────────────────────────────────────────────╮
│                                                             │
│     🔍 Git Configuration Verification                      │
│     Checking all components are properly configured        │
│                                                             │
╰─────────────────────────────────────────────────────────────╯
EOF
    echo -e "${NC}"
    
    local all_good=true
    
    # Check core Git files
    log_header "Configuration Files"
    check_file "$HOME/.dotfiles/git/.gitconfig" "Main Git config" || all_good=false
    check_file "$HOME/.dotfiles/.config/git/config" "Enhanced Git config" || all_good=false
    check_file "$HOME/.dotfiles/zsh/aliases/git.sh" "Shell aliases" || all_good=false
    
    # Check tool configurations  
    log_header "Tool Configurations"
    check_file "$HOME/.dotfiles/.config/lazygit/config.yml" "LazyGit config" || all_good=false
    check_file "$HOME/.dotfiles/.config/gh/config.yml" "GitHub CLI config" || all_good=false
    check_file "$HOME/.dotfiles/.config/gitui/theme.ron" "GitUI theme" || all_good=false
    check_file "$HOME/.dotfiles/.config/gitui/key_bindings.ron" "GitUI keybindings" || all_good=false
    
    # Check if tools are installed
    log_header "Tool Installation"
    check_command "git" "Git" || all_good=false
    check_command "delta" "Delta" || all_good=false
    check_command "lazygit" "LazyGit" || all_good=false
    check_command "gh" "GitHub CLI" || all_good=false
    check_command "gitui" "GitUI" || all_good=false
    
    # Test Git configuration
    test_git_aliases || all_good=false
    
    # Test shell aliases
    test_shell_aliases || all_good=false
    
    # Check current Git configuration status
    log_header "Current Git Settings"
    if git config user.name >/dev/null 2>&1; then
        log_success "Git user.name: $(git config user.name)"
    else
        log_warning "Git user.name not set"
    fi
    
    if git config user.email >/dev/null 2>&1; then
        log_success "Git user.email: $(git config user.email)"
    else
        log_warning "Git user.email not set"
    fi
    
    if git config core.pager >/dev/null 2>&1; then
        log_success "Git pager: $(git config core.pager)"
    else
        log_warning "Git pager not configured"
    fi
    
    # Final result
    log_header "Verification Result"
    if $all_good; then
        log_success "All components verified successfully! 🎉"
        echo ""
        echo "🚀 Your enhanced Git workflow is ready!"
        echo "   • Try 'lg' for LazyGit"
        echo "   • Try 'gu' for GitUI"  
        echo "   • Try 'gss' for enhanced status"
        echo "   • Run 'git-help' for all aliases"
        echo "   • Run 'gh auth login' to setup GitHub"
        return 0
    else
        log_error "Some components failed verification"
        echo ""
        echo "🔧 To fix issues:"
        echo "   • Run: ~/.dotfiles/git/setup.sh"
        echo "   • Check file permissions"
        echo "   • Restart your shell"
        return 1
    fi
}

# Run verification
main "$@"