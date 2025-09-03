#!/usr/bin/env bash
# ============================================================================
# Modern CLI Tools Integration
# ============================================================================
# Enhanced command-line utilities with fallback mechanisms
# Compatible with existing dotfiles structure

# ============================================================================
# ENHANCED FILE LISTING - EZA/LSD/LS Chain
# ============================================================================

if command -v eza >/dev/null 2>&1; then
    # Eza (modern ls replacement) - primary choice
    alias ls='eza --color=auto --group-directories-first'
    alias ll='eza -l --color=auto --group-directories-first --git'
    alias la='eza -la --color=auto --group-directories-first --git'
    alias lt='eza --tree --color=auto --level=2'
    alias ltl='eza -l --tree --color=auto --level=3 --git'
    alias lta='eza -la --tree --color=auto --level=2'
    # Extra eza-specific aliases
    alias lg='eza -l --git --git-ignore'
    alias lm='eza -l --sort=modified'
    alias ls='eza -l --sort=size'
elif command -v lsd >/dev/null 2>&1; then
    # LSD fallback
    alias ls='lsd --color=auto'
    alias ll='lsd -l --color=auto'
    alias la='lsd -la --color=auto'
    alias lt='lsd --tree --depth=2'
elif command -v gls >/dev/null 2>&1; then
    # GNU ls fallback (via brew)
    alias ls='gls --color=auto --group-directories-first'
    alias ll='gls -lh --color=auto --group-directories-first'
    alias la='gls -lah --color=auto --group-directories-first'
else
    # macOS default ls fallback
    alias ls='ls -G'
    alias ll='ls -lhG'
    alias la='ls -lahG'
fi

# ============================================================================
# ENHANCED TEXT VIEWING - BAT/CAT Chain
# ============================================================================

if command -v bat >/dev/null 2>&1; then
    alias cat='bat --style=auto'
    alias catp='bat --style=plain'
    alias catl='bat --style=numbers'
    export BAT_THEME="Dracula"
    export BAT_STYLE="numbers,changes,header"
    # Bat-specific functions
    batdiff() {
        git diff --name-only --relative --diff-filter=d | xargs bat --diff
    }
    batlog() {
        git log --oneline --decorate --color=always | head -20 | bat --style=plain --language=gitlog
    }
fi

# ============================================================================
# ENHANCED SEARCH - FD/FIND Chain
# ============================================================================

if command -v fd >/dev/null 2>&1; then
    alias find='fd'
    alias findh='fd --hidden'
    alias findt='fd --type f'
    alias findd='fd --type d'
    # Advanced fd functions
    fda() {
        fd --type f --hidden --follow --exclude .git "$@"
    }
fi

# ============================================================================
# ENHANCED GREP - RIPGREP/GREP Chain
# ============================================================================

if command -v rg >/dev/null 2>&1; then
    alias grep='rg'
    alias grepi='rg -i'
    alias grepl='rg --files-with-matches'
    alias grepv='rg --invert-match'
    # Advanced ripgrep functions
    rga() {
        rg --type-add 'config:*.{conf,config,ini,toml,yaml,yml}' --type config "$@"
    }
    rgjs() {
        rg --type js --type ts --type jsx --type tsx "$@"
    }
fi

# ============================================================================
# ENHANCED DISK USAGE - DUST/DU Chain
# ============================================================================

if command -v dust >/dev/null 2>&1; then
    alias du='dust'
    alias dus='dust --depth 1'
    alias duh='dust --depth 2'
elif command -v duf >/dev/null 2>&1; then
    alias df='duf'
fi

# ============================================================================
# ENHANCED PROCESS MONITORING - BTOP/HTOP/TOP Chain
# ============================================================================

if command -v btop >/dev/null 2>&1; then
    alias top='btop'
    alias htop='btop'
elif command -v htop >/dev/null 2>&1; then
    alias top='htop'
fi

if command -v procs >/dev/null 2>&1; then
    alias ps='procs'
    alias pst='procs --tree'
    alias psm='procs --sortd memory'
    alias psc='procs --sortd cpu'
fi

# ============================================================================
# NAVIGATION ENHANCEMENTS - ZOXIDE INTEGRATION
# ============================================================================

if command -v zoxide >/dev/null 2>&1; then
    # Initialize zoxide
    eval "$(zoxide init zsh)"
    
    # Enhanced aliases
    alias cd='z'
    alias cdi='zi'  # Interactive cd
    alias cdb='z -'  # Go back
    
    # Advanced zoxide functions
    zd() {
        # Quick directory jump with preview
        local dir
        dir=$(zoxide query -l | fzf --height 40% --reverse --preview 'eza --color=always {}' --preview-window right:50%) && z "$dir"
    }
fi

# ============================================================================
# HISTORY ENHANCEMENT - ATUIN INTEGRATION
# ============================================================================

if command -v atuin >/dev/null 2>&1; then
    # Initialize atuin
    eval "$(atuin init zsh --disable-up-arrow)"
    
    # Atuin keybindings
    bindkey '^r' atuin-search
    bindkey '^[[A' atuin-up-search
    bindkey '^[OA' atuin-up-search
    
    # Atuin aliases and functions
    alias history='atuin history'
    alias hs='atuin search'
    alias hst='atuin stats'
    
    # Advanced atuin functions
    hsync() {
        echo "Syncing history with Atuin..."
        atuin sync
    }
fi

# ============================================================================
# GIT ENHANCEMENTS - DELTA/LAZYGIT/GITUI Integration
# ============================================================================

if command -v delta >/dev/null 2>&1; then
    # Configure git to use delta
    git config --global core.pager delta
    git config --global interactive.diffFilter 'delta --color-only'
    git config --global delta.navigate true
    git config --global delta.light false
    git config --global merge.conflictstyle diff3
fi

if command -v lazygit >/dev/null 2>&1; then
    alias lg='lazygit'
    alias git-ui='lazygit'
elif command -v gitui >/dev/null 2>&1; then
    alias lg='gitui'
    alias git-ui='gitui'
fi

# ============================================================================
# FILE MANAGEMENT - YAZI/TRASH Integration
# ============================================================================

if command -v yazi >/dev/null 2>&1; then
    alias fm='yazi'
    alias files='yazi'
    
    # Yazi wrapper function to change directory on exit
    ya() {
        local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
        yazi "$@" --cwd-file="$tmp"
        if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
            cd -- "$cwd"
        fi
        rm -f -- "$tmp"
    }
elif command -v nnn >/dev/null 2>&1; then
    alias fm='nnn'
fi

if command -v trash >/dev/null 2>&1; then
    alias rm='trash'
    alias rmi='trash'  # Interactive mode handled by trash
    # Keep real rm available as rr
    alias rr='/bin/rm'
fi

# ============================================================================
# MARKDOWN & DOCUMENTATION - GLOW Integration
# ============================================================================

if command -v glow >/dev/null 2>&1; then
    alias md='glow'
    alias markdown='glow'
    alias readme='glow README.md'
    
    # Glow functions
    mdp() {
        # Preview markdown with paging
        glow -p "$@"
    }
    
    mds() {
        # Styled markdown output
        glow -s auto "$@"
    }
fi

# ============================================================================
# BENCHMARKING - HYPERFINE Integration
# ============================================================================

if command -v hyperfine >/dev/null 2>&1; then
    alias bench='hyperfine'
    alias benchmark='hyperfine'
    
    # Benchmark functions
    benchcmd() {
        # Quick command benchmark
        hyperfine --warmup 3 "$@"
    }
    
    benchcomp() {
        # Compare multiple commands
        hyperfine --warmup 2 "$@"
    }
fi

# ============================================================================
# CODE STATISTICS - TOKEI Integration
# ============================================================================

if command -v tokei >/dev/null 2>&1; then
    alias loc='tokei'
    alias lines='tokei'
    alias stats='tokei'
    
    # Tokei functions
    locs() {
        # Summary view
        tokei --sort lines
    }
    
    locf() {
        # Show files
        tokei --files
    }
fi

# ============================================================================
# SYSTEM INFORMATION - NEOFETCH Integration
# ============================================================================

if command -v neofetch >/dev/null 2>&1; then
    alias sysinfo='neofetch'
    alias info='neofetch'
fi

# ============================================================================
# NETWORK UTILITIES
# ============================================================================

if command -v bandwhich >/dev/null 2>&1; then
    alias net='bandwhich'
    alias netmon='bandwhich'
fi

if command -v httpie >/dev/null 2>&1; then
    alias http='http --style=auto'
    alias https='https --style=auto'
fi

if command -v speedtest-cli >/dev/null 2>&1; then
    alias speedtest='speedtest-cli'
fi

# ============================================================================
# DIRECTORY NAVIGATION - BROOT Integration
# ============================================================================

if command -v broot >/dev/null 2>&1; then
    # Initialize broot - check if launcher exists first
    if [[ -f "$HOME/.config/broot/launcher/bash/br" ]]; then
        source "$HOME/.config/broot/launcher/bash/br" 2>/dev/null
    fi
    
    alias tree='broot'
    alias br='broot'
    
    # Broot functions
    brs() {
        # Search with broot
        broot --only-folders
    }
fi

# ============================================================================
# HELP SYSTEM - TLDR Integration
# ============================================================================

if command -v tldr >/dev/null 2>&1; then
    alias help='tldr'
    alias manual='tldr'
    
    # TLDR functions
    helpu() {
        # Update tldr cache
        tldr --update
    }
fi

# ============================================================================
# MULTIPLEXER ALTERNATIVES - ZELLIJ Integration
# ============================================================================

if command -v zellij >/dev/null 2>&1; then
    alias zj='zellij'
    alias mux='zellij'
    
    # Zellij functions
    zs() {
        # Start or attach to session
        if [ -n "$1" ]; then
            zellij attach "$1" || zellij -s "$1"
        else
            zellij attach || zellij
        fi
    }
fi

# ============================================================================
# PROMPT ENHANCEMENT - STARSHIP Integration
# ============================================================================

if command -v starship >/dev/null 2>&1; then
    # Initialize starship prompt
    eval "$(starship init zsh)"
fi

# ============================================================================
# UTILITY FUNCTIONS
# ============================================================================

# Check if all modern tools are installed
check-modern-tools() {
    echo "🔍 Checking modern CLI tools installation:"
    echo ""
    
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
        "glow:Markdown viewer"
        "hyperfine:Benchmarking tool"
        "tokei:Code statistics"
        "broot:Directory navigator"
        "trash:Safe rm"
        "tldr:Simplified man pages"
        "procs:Enhanced ps"
        "bandwhich:Network monitor"
    )
    
    for tool_info in "${tools[@]}"; do
        local tool="${tool_info%:*}"
        local desc="${tool_info#*:}"
        
        if command -v "$tool" >/dev/null 2>&1; then
            echo "✅ $tool - $desc"
        else
            echo "❌ $tool - $desc (not installed)"
        fi
    done
    echo ""
    echo "💡 Run 'install-modern-cli' to install missing tools"
}

# Install modern tools (requires the install script)
install-modern-cli() {
    if [ -f "$HOME/.dotfiles/brew/install-modern-cli.sh" ]; then
        "$HOME/.dotfiles/brew/install-modern-cli.sh" "$@"
    else
        echo "❌ Installation script not found at ~/.dotfiles/brew/install-modern-cli.sh"
        return 1
    fi
}

# Quick help for modern tools
modern-help() {
    cat << 'EOF'
🚀 Modern CLI Tools Quick Reference:

📁 File Operations:
   ls, ll, la        → Enhanced directory listing (eza)
   cat               → Enhanced file viewing (bat)
   find              → Enhanced file search (fd)
   grep              → Enhanced text search (rg)
   du                → Enhanced disk usage (dust)
   rm                → Safe deletion (trash)

🧭 Navigation:
   cd                → Smart directory jumping (zoxide)
   z <partial-path>  → Jump to directory
   zi                → Interactive directory selection
   fm, ya            → Terminal file manager (yazi)
   br                → Directory tree navigator (broot)

📊 System Monitoring:
   top, htop         → Enhanced system monitor (btop)
   ps                → Enhanced process list (procs)
   net               → Network monitor (bandwhich)
   info              → System information (neofetch)

🔧 Development:
   lg                → Git TUI (lazygit)
   md                → Markdown viewer (glow)
   bench             → Benchmarking (hyperfine)
   loc               → Code statistics (tokei)
   help <cmd>        → Quick help (tldr)

🕒 History & Prompt:
   Ctrl+R            → Smart history search (atuin)
   <prompt>          → Enhanced prompt (starship)

🛠  Utilities:
   check-modern-tools → Check installation status
   install-modern-cli → Install missing tools
   modern-help        → This help message

EOF
}

# ============================================================================
# INITIALIZATION MESSAGES (Optional)
# ============================================================================

# Uncomment to show a brief status on shell startup
# if [[ -n "$PS1" ]] && [[ -z "$MODERN_CLI_QUIET" ]]; then
#     echo "🚀 Modern CLI tools loaded. Type 'modern-help' for quick reference."
# fi