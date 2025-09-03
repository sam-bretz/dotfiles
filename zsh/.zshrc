#Start at home dir (tmux and other complains when initianting from non ~ dirs)
cd ~

# Vars 
USER=$(whoami)
CLOUD_PATH="/Users/$USER/Library/Mobile Documents/com~apple~CloudDocs"
DOTFILE_PATH='~/.dotfiles'

# Load secure environment variables (if available)
[ -f ~/.env.local ] && source ~/.env.local

# ============================================================================
# ZSH OPTIONS - Modern Shell Enhancements
# ============================================================================

# History Optimization
setopt HIST_IGNORE_SPACE      # Don't record commands starting with space
setopt SHARE_HISTORY          # Share history between all sessions
setopt HIST_VERIFY           # Show command before executing from history
setopt HIST_IGNORE_DUPS      # Don't record duplicates
setopt HIST_EXPIRE_DUPS_FIRST # Delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt HIST_FIND_NO_DUPS     # Don't show duplicates in history search
setopt HIST_REDUCE_BLANKS    # Remove superfluous blanks from history
setopt EXTENDED_HISTORY      # Save timestamp and duration

# Directory Navigation
setopt AUTO_PUSHD            # Push old directory onto directory stack
setopt PUSHD_IGNORE_DUPS     # Don't push duplicates onto stack
setopt PUSHD_SILENT          # Don't print directory stack after pushd/popd
setopt PUSHD_TO_HOME         # Have pushd with no arguments act like 'pushd $HOME'
setopt CDABLE_VARS           # Change directory to variable if not directory

# Globbing and Expansion
setopt EXTENDED_GLOB         # Use extended globbing syntax
setopt GLOB_DOTS             # Include dotfiles in glob patterns
setopt NULL_GLOB             # Don't error on empty glob patterns

# Job Control
setopt LONG_LIST_JOBS        # Display PID when suspending processes
setopt NO_HUP                # Don't kill jobs on shell exit
setopt CHECK_JOBS            # Report status of jobs before exiting

# Command Line Editing
setopt NO_BEEP               # Disable beeping
setopt INTERACTIVE_COMMENTS  # Allow comments in interactive shell

# History Configuration
HISTSIZE=50000               # Internal history size
SAVEHIST=50000              # History file size
HISTFILE=~/.zsh_history     # History file location

# ============================================================================
# ALIAS SYSTEM - Organized by Category
# ============================================================================

# Load aliases in order of dependency
alias_files=(
  "utils.sh"        # General utilities (base layer)
  "shorthand.sh"    # Quick shortcuts
  "modern-cli.sh"   # Modern CLI tool replacements
  "configs.sh"      # Configuration file shortcuts
  "dirs.sh"         # Directory and project shortcuts
  "git.sh"          # Git workflow enhancements
  "docker.sh"       # Container operations
  "npm.sh"          # Node.js package management
)

# Load aliases silently (no console output for P10k compatibility)
for alias_file in "${alias_files[@]}"; do
  alias_path="$HOME/.dotfiles/zsh/aliases/$alias_file"
  if [[ -r "$alias_path" ]]; then
    source "$alias_path" 2>/dev/null
  fi
done


# Add macTex to path
export PATH="/Library/TeX/texbin:$PATH"


# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH
# Path to your oh-my-zsh installation.
export ZSH=".oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
#ZSH_THEME="robbyrussell"
ZSH_THEME="powerlevel10k/powerlevel10k"

# Uncomment the following line to use case-sensitive completion.
CASE_SENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
zstyle ':omz:update' mode auto      # update automatically without asking

# Uncomment the following line to change how often to auto-update (in days).
zstyle ':omz:update' frequency 13

# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
  zsh-completions
  docker
  docker-compose
  kubectl
  brew
  macos
  colored-man-pages
  command-not-found
)

# Add zsh-completions to fpath before sourcing oh-my-zsh
fpath+=${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions/src

source $ZSH/oh-my-zsh.sh

# ============================================================================
# MODERN INTEGRATIONS & COMPLETIONS
# ============================================================================

# FZF Integration (Fuzzy Finder)
if command -v fzf >/dev/null 2>&1; then
  # Source FZF key bindings and completions
  [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
  
  # FZF Configuration
  export FZF_DEFAULT_OPTS='
    --height 40%
    --layout=reverse
    --border
    --preview "echo {} | head -500"
    --color=fg:#f8f8f2,bg:#282a36,hl:#bd93f9
    --color=fg+:#f8f8f2,bg+:#44475a,hl+:#bd93f9
    --color=info:#ffb86c,prompt:#50fa7b,pointer:#ff79c6
    --color=marker:#ff79c6,spinner:#ffb86c,header:#6272a4
  '
  
  # Use fd for file searching if available
  if command -v fd >/dev/null 2>&1; then
    export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  fi
  
  # Use ripgrep for content searching if available
  if command -v rg >/dev/null 2>&1; then
    export FZF_ALT_C_COMMAND='fd --type d . --color=never --hidden --follow --exclude .git'
  fi
fi

# Kubernetes Completions
if command -v kubectl >/dev/null 2>&1; then
  source <(kubectl completion zsh)
  # Alias for kubectl
  alias k=kubectl
  complete -F __start_kubectl k
fi

# Docker Completions
if command -v docker >/dev/null 2>&1; then
  # Docker completion is handled by the docker plugin
  # Docker aliases are defined in aliases/docker.sh
  :
fi

# Homebrew Completions
if command -v brew >/dev/null 2>&1; then
  FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"
fi

# Enable zsh-completions
autoload -U compinit && compinit

# ============================================================================
# ENHANCED COMPLETION CONFIGURATION
# ============================================================================

# Completion styling
zstyle ':completion:*' menu select
zstyle ':completion:*' group-name ''
zstyle ':completion:*' verbose yes
zstyle ':completion:*:descriptions' format '%B%d%b'
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:warnings' format 'No matches for: %d'
zstyle ':completion:*' completer _expand _complete _approximate _ignored

# Case-insensitive completion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

# Completion caching
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache

# Directory completion colors
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*:*:cd:*:directory-stack' menu yes select

# Kill command completion
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'
zstyle ':completion:*:*:*:*:processes' command "ps -u $USER -o pid,user,comm -w -w"

# SSH/SCP/RSYNC hostname completion
zstyle ':completion:*:(ssh|scp|rsync):*' tag-order 'hosts:-host:host hosts:-domain:domain hosts:-ipaddr:ip\ address *'
zstyle ':completion:*:(scp|rsync):*' group-order users files all-files hosts-domain hosts-host hosts-ipaddr
zstyle ':completion:*:ssh:*' group-order users hosts-domain hosts-host users hosts-ipaddr

# ============================================================================
# DIRECTORY NAVIGATION ENHANCEMENTS
# ============================================================================

# Directory navigation aliases moved to aliases/utils.sh

# ============================================================================
# MODERN SHELL UTILITIES
# ============================================================================

# ============================================================================
# MODERN CLI TOOLS INTEGRATION
# ============================================================================
# Enhanced tools are now managed in separate alias files for better organization
# Legacy aliases below are preserved for compatibility but may be overridden

# Initialize modern CLI tools (zoxide, atuin, starship)
# These need early initialization before other tools

# Zoxide (smart cd) - must be initialized early
if command -v zoxide >/dev/null 2>&1; then
    eval "$(zoxide init zsh)"
fi

# Atuin (smart history) - must be initialized early  
if command -v atuin >/dev/null 2>&1; then
    eval "$(atuin init zsh --disable-up-arrow)"
fi

# Starship (modern prompt) - will be initialized after oh-my-zsh
# Note: This may override powerlevel10k if both are present

# Legacy tool integrations (preserved for compatibility)
# These will be enhanced/overridden by modern-cli.sh

# Better ls with colors and human-readable sizes
if command -v eza >/dev/null 2>&1; then
  alias ls='eza --color=auto'
  alias ll='eza -l --color=auto --group-directories-first'
  alias la='eza -la --color=auto --group-directories-first'
  alias lt='eza --tree --color=auto'
elif command -v exa >/dev/null 2>&1; then
  alias ls='exa --color=auto'
  alias ll='exa -l --color=auto --group-directories-first'
  alias la='exa -la --color=auto --group-directories-first'
  alias lt='exa --tree --color=auto'
elif command -v gls >/dev/null 2>&1; then  # GNU ls via brew
  alias ls='gls --color=auto'
  alias ll='gls -lh --color=auto --group-directories-first'
  alias la='gls -lah --color=auto --group-directories-first'
else  # macOS default ls
  alias ls='ls -G'
  alias ll='ls -lhG'
  alias la='ls -lahG'
fi

# Better cat with syntax highlighting
if command -v bat >/dev/null 2>&1; then
  alias cat='bat'
  export BAT_THEME="Dracula"
fi

# Better find
if command -v fd >/dev/null 2>&1; then
  alias find='fd'
fi

# Better grep
if command -v rg >/dev/null 2>&1; then
  alias grep='rg'
fi

# Better du
if command -v dust >/dev/null 2>&1; then
  alias du='dust'
fi

# Better top
if command -v btop >/dev/null 2>&1; then
  alias top='btop'
elif command -v htop >/dev/null 2>&1; then
  alias top='htop'
fi

# ============================================================================
# POST OH-MY-ZSH INITIALIZATION
# ============================================================================

# Initialize Starship prompt (if available and not using powerlevel10k)
# This will override oh-my-zsh themes including powerlevel10k
if command -v starship >/dev/null 2>&1; then
    # Only init starship if powerlevel10k config doesn't exist or user prefers starship
    if [[ ! -f ~/.p10k.zsh ]] || [[ "$PREFER_STARSHIP" == "true" ]]; then
        eval "$(starship init zsh)"
    else
        # Keep powerlevel10k if config exists and no preference set
        [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
    fi
else
    # Fallback to powerlevel10k if available
    [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
fi

# ============================================================================
# FINAL MODERN CLI INTEGRATIONS
# ============================================================================

# Initialize additional tools that need to be loaded after oh-my-zsh

# McFly (neural network powered history) - alternative to atuin
if command -v mcfly >/dev/null 2>&1; then
    eval "$(mcfly init zsh)"
fi

# Broot directory navigator
if command -v broot >/dev/null 2>&1; then
    # Source broot launcher if it exists
    if [[ -f ~/.config/broot/launcher/bash/br ]]; then
        source ~/.config/broot/launcher/bash/br
    fi
fi

# Enable additional completions for modern tools
if command -v zoxide >/dev/null 2>&1; then
    # Zoxide completions are handled by its init
    :
fi

if command -v atuin >/dev/null 2>&1; then
    # Additional atuin key bindings
    bindkey '^r' atuin-search
    # Only bind up arrow if not conflicting with existing bindings
    if [[ -z "${widgets[up-line-or-beginning-search]}" ]]; then
        bindkey '^[[A' atuin-up-search
        bindkey '^[OA' atuin-up-search
    fi
fi

# Set up modern tool configurations
export PATH="$HOME/bin:$PATH"

# Optional: Set preference for prompt
# Uncomment the next line to prefer Starship over Powerlevel10k
# export PREFER_STARSHIP=true
