#!/usr/bin/env zsh
# ============================================================================
# General Utilities - System & Development Tools
# ============================================================================

# System utilities
alias reload='source ~/.zshrc'
alias path='echo $PATH | tr ":" "\n"'
alias fpath='echo $FPATH | tr ":" "\n"'
alias aliases='alias | grep -E "^[a-zA-Z]" | sort'
alias functions='declare -f | grep -E "^[a-zA-Z]" | sed "s/ *{$//"'

# File operations
alias cp='cp -iv'                    # Interactive, verbose
alias mv='mv -iv'                    # Interactive, verbose
alias mkdir='mkdir -pv'              # Create parents, verbose
alias rmdir='rmdir -v'               # Verbose
alias ln='ln -v'                     # Verbose
alias chmod='chmod -v'               # Verbose
alias chown='chown -v'               # Verbose

# Enhanced ls aliases (fallbacks for when modern tools aren't available)
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias lt='tree -L 2'
alias ltr='tree -L 3 -r'

# Directory navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias -- -='cd -'

# Smart directory stack (use 'dirs -v' to see stack)
alias d='dirs -v | head -10'
alias 1='cd -1'
alias 2='cd -2'
alias 3='cd -3'
alias 4='cd -4'
alias 5='cd -5'
alias 6='cd -6'
alias 7='cd -7'
alias 8='cd -8'
alias 9='cd -9'

# Quick directory shortcuts
alias h='cd ~'
alias desktop='cd ~/Desktop'
alias downloads='cd ~/Downloads'
alias documents='cd ~/Documents'

# Process management
alias psg='ps aux | grep'
alias killall='killall -v'
alias jobs='jobs -l'

# Network utilities
alias ping='ping -c 5'
alias ports='lsof -i -P -n | grep LISTEN'
alias myip='curl -s https://ipinfo.io/ip'
alias localip="ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1'"
alias speedtest='curl -s https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py | python -'

# Archive utilities
alias targz='tar -czf'
alias tarls='tar -tzf'
alias untar='tar -xzf'
alias tarxz='tar -cJf'
alias untarxz='tar -xJf'

# Date and time
alias now='date "+%Y-%m-%d %H:%M:%S"'
alias nowutc='date -u "+%Y-%m-%d %H:%M:%S UTC"'
alias timestamp='date +%s'
alias week='date +%V'

# Text processing
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias count='wc -l'
alias lower='tr "[:upper:]" "[:lower:]"'
alias upper='tr "[:lower:]" "[:upper:]"'

# System monitoring
alias disk='df -h'
alias mem='free -h'
alias cpu='top -o cpu'
alias load='uptime'

# Enhanced utility functions
function mkcd() {
    if [[ -z "$1" ]]; then
        echo "Usage: mkcd <directory>"
        return 1
    fi
    mkdir -pv "$1" && cd "$1"
}

function extract() {
    if [[ -z "$1" ]]; then
        echo "Usage: extract <archive-file>"
        echo "Supports: .tar, .tar.gz, .tar.bz2, .tar.xz, .zip, .rar, .7z, .gz, .bz2, .xz"
        return 1
    fi
    
    if [[ ! -f "$1" ]]; then
        echo "❌ File not found: $1"
        return 1
    fi
    
    echo "📦 Extracting: $1"
    
    case "$1" in
        *.tar.bz2|*.tbz2) tar xjf "$1" ;;
        *.tar.gz|*.tgz)   tar xzf "$1" ;;
        *.tar.xz|*.txz)   tar xJf "$1" ;;
        *.tar)            tar xf "$1" ;;
        *.bz2)            bunzip2 "$1" ;;
        *.gz)             gunzip "$1" ;;
        *.xz)             unxz "$1" ;;
        *.zip)            unzip "$1" ;;
        *.rar)            unrar x "$1" ;;
        *.7z)             7z x "$1" ;;
        *.Z)              uncompress "$1" ;;
        *.lzma)           unlzma "$1" ;;
        *)                echo "❌ Unsupported format: $1" ;;
    esac
}

function backup() {
    if [[ -z "$1" ]]; then
        echo "Usage: backup <file-or-directory>"
        return 1
    fi
    
    local target="$1"
    local backup_name="${target}.backup.$(date +%Y%m%d_%H%M%S)"
    
    if [[ -f "$target" ]] || [[ -d "$target" ]]; then
        cp -r "$target" "$backup_name"
        echo "✅ Backup created: $backup_name"
    else
        echo "❌ File or directory not found: $target"
        return 1
    fi
}

function findfile() {
    if [[ -z "$1" ]]; then
        echo "Usage: findfile <filename>"
        return 1
    fi
    
    find . -name "*$1*" -type f 2>/dev/null
}

function finddir() {
    if [[ -z "$1" ]]; then
        echo "Usage: finddir <dirname>"
        return 1
    fi
    
    find . -name "*$1*" -type d 2>/dev/null
}

function findtext() {
    if [[ -z "$1" ]]; then
        echo "Usage: findtext <search-term>"
        return 1
    fi
    
    grep -r --include="*.txt" --include="*.md" --include="*.js" --include="*.ts" --include="*.json" --include="*.yaml" --include="*.yml" "$1" . 2>/dev/null
}

function weather() {
    local location="${1:-}"
    if [[ -n "$location" ]]; then
        curl -s "wttr.in/$location"
    else
        curl -s "wttr.in/"
    fi
}

function qr() {
    if [[ -z "$1" ]]; then
        echo "Usage: qr <text-or-url>"
        return 1
    fi
    
    if command -v qrencode >/dev/null 2>&1; then
        qrencode -t ansiutf8 "$1"
    else
        curl -s "qrenco.de/$1"
    fi
}

function serve() {
    local port="${1:-8000}"
    echo "🌐 Starting HTTP server on port $port"
    echo "📂 Serving: $(pwd)"
    echo "🔗 URL: http://localhost:$port"
    echo "Press Ctrl+C to stop"
    
    if command -v python3 >/dev/null 2>&1; then
        python3 -m http.server "$port"
    elif command -v python >/dev/null 2>&1; then
        python -m SimpleHTTPServer "$port"
    elif command -v ruby >/dev/null 2>&1; then
        ruby -run -e httpd . -p "$port"
    elif command -v php >/dev/null 2>&1; then
        php -S "localhost:$port"
    else
        echo "❌ No suitable HTTP server found (python, ruby, or php required)"
        return 1
    fi
}

function genpass() {
    local length="${1:-16}"
    local chars="${2:-A-Za-z0-9!@#$%^&*()_+-=[]{}|;:,.<>?}"
    
    if command -v openssl >/dev/null 2>&1; then
        openssl rand -base64 32 | tr -d "=+/" | cut -c1-"$length"
    elif [[ -c /dev/urandom ]]; then
        < /dev/urandom tr -dc "$chars" | head -c"$length" && echo
    else
        echo "❌ Unable to generate password (openssl or /dev/urandom required)"
        return 1
    fi
}

function hash() {
    if [[ -z "$1" ]]; then
        echo "Usage: hash <string> [algorithm]"
        echo "Algorithms: md5, sha1, sha256, sha512"
        return 1
    fi
    
    local string="$1"
    local algorithm="${2:-sha256}"
    
    case "$algorithm" in
        md5)
            if command -v md5sum >/dev/null 2>&1; then
                echo -n "$string" | md5sum | cut -d' ' -f1
            elif command -v md5 >/dev/null 2>&1; then
                echo -n "$string" | md5
            fi
            ;;
        sha1)
            if command -v sha1sum >/dev/null 2>&1; then
                echo -n "$string" | sha1sum | cut -d' ' -f1
            elif command -v shasum >/dev/null 2>&1; then
                echo -n "$string" | shasum | cut -d' ' -f1
            fi
            ;;
        sha256)
            if command -v sha256sum >/dev/null 2>&1; then
                echo -n "$string" | sha256sum | cut -d' ' -f1
            elif command -v shasum >/dev/null 2>&1; then
                echo -n "$string" | shasum -a 256 | cut -d' ' -f1
            fi
            ;;
        sha512)
            if command -v sha512sum >/dev/null 2>&1; then
                echo -n "$string" | sha512sum | cut -d' ' -f1
            elif command -v shasum >/dev/null 2>&1; then
                echo -n "$string" | shasum -a 512 | cut -d' ' -f1
            fi
            ;;
        *)
            echo "❌ Unsupported algorithm: $algorithm"
            return 1
            ;;
    esac
}

function encode() {
    if [[ -z "$1" ]]; then
        echo "Usage: encode <string> [format]"
        echo "Formats: base64, url"
        return 1
    fi
    
    local string="$1"
    local format="${2:-base64}"
    
    case "$format" in
        base64)
            echo -n "$string" | base64
            ;;
        url)
            echo -n "$string" | python3 -c "import urllib.parse; print(urllib.parse.quote(input()))"
            ;;
        *)
            echo "❌ Unsupported format: $format"
            return 1
            ;;
    esac
}

function decode() {
    if [[ -z "$1" ]]; then
        echo "Usage: decode <string> [format]"
        echo "Formats: base64, url"
        return 1
    fi
    
    local string="$1"
    local format="${2:-base64}"
    
    case "$format" in
        base64)
            echo -n "$string" | base64 -d
            ;;
        url)
            echo -n "$string" | python3 -c "import urllib.parse; print(urllib.parse.unquote(input()))"
            ;;
        *)
            echo "❌ Unsupported format: $format"
            return 1
            ;;
    esac
}

function jsonformat() {
    if [[ -z "$1" ]]; then
        echo "Usage: jsonformat <json-string-or-file>"
        return 1
    fi
    
    if [[ -f "$1" ]]; then
        if command -v jq >/dev/null 2>&1; then
            jq '.' "$1"
        else
            python3 -m json.tool "$1"
        fi
    else
        if command -v jq >/dev/null 2>&1; then
            echo "$1" | jq '.'
        else
            echo "$1" | python3 -m json.tool
        fi
    fi
}

function yamltojson() {
    if [[ -z "$1" ]]; then
        echo "Usage: yamltojson <yaml-file>"
        return 1
    fi
    
    if command -v yq >/dev/null 2>&1; then
        yq eval -o json "$1"
    elif command -v python3 >/dev/null 2>&1; then
        python3 -c "import yaml, json, sys; print(json.dumps(yaml.safe_load(open('$1')), indent=2))"
    else
        echo "❌ yq or python3 with PyYAML required"
        return 1
    fi
}

function urlencode() {
    if [[ -z "$1" ]]; then
        echo "Usage: urlencode <string>"
        return 1
    fi
    
    python3 -c "import urllib.parse; print(urllib.parse.quote('$1'))"
}

function urldecode() {
    if [[ -z "$1" ]]; then
        echo "Usage: urldecode <encoded-string>"
        return 1
    fi
    
    python3 -c "import urllib.parse; print(urllib.parse.unquote('$1'))"
}

function calc() {
    if [[ -z "$1" ]]; then
        echo "Usage: calc <expression>"
        echo "Examples: calc '2+2', calc '10*5', calc 'sqrt(16)'"
        return 1
    fi
    
    if command -v bc >/dev/null 2>&1; then
        echo "$1" | bc -l
    else
        python3 -c "import math; print($1)"
    fi
}

function timer() {
    local seconds="${1:-60}"
    local message="${2:-Time's up!}"
    
    echo "⏰ Timer set for $seconds seconds"
    sleep "$seconds" && echo "🔔 $message" && 
    if command -v say >/dev/null 2>&1; then
        say "$message"
    elif command -v espeak >/dev/null 2>&1; then
        espeak "$message"
    fi
}

function stopwatch() {
    local start_time=$(date +%s)
    echo "⏱️  Stopwatch started. Press any key to stop."
    read -r
    local end_time=$(date +%s)
    local elapsed=$((end_time - start_time))
    local minutes=$((elapsed / 60))
    local seconds=$((elapsed % 60))
    echo "⏱️  Elapsed time: ${minutes}m ${seconds}s"
}

function colors() {
    echo "🌈 Terminal color test:"
    for i in {0..255}; do
        printf "\e[38;5;${i}m%3d\e[0m " $i
        if (( (i + 1) % 16 == 0 )); then
            echo
        fi
    done
    echo
}

function sysinfo() {
    echo "💻 System Information:"
    echo "OS: $(uname -s)"
    echo "Kernel: $(uname -r)"
    echo "Architecture: $(uname -m)"
    echo "Hostname: $(hostname)"
    echo "Uptime: $(uptime | sed 's/.*up \([^,]*\),.*/\1/')"
    echo "Shell: $SHELL"
    echo "Terminal: $TERM"
    echo "User: $(whoami)"
    echo "Date: $(date)"
    
    if [[ "$(uname)" == "Darwin" ]]; then
        echo "macOS Version: $(sw_vers -productVersion)"
    elif [[ -f /etc/os-release ]]; then
        . /etc/os-release
        echo "Distribution: $NAME"
    fi
}

function diskusage() {
    echo "💾 Disk Usage Summary:"
    df -h | grep -E '^/dev/' | awk '{print $1 ": " $3 "/" $2 " (" $5 " full)"}' | column -t
    
    echo ""
    echo "📁 Largest directories in current path:"
    if command -v dust >/dev/null 2>&1; then
        dust --depth 1 | head -10
    else
        du -h . 2>/dev/null | sort -hr | head -10
    fi
}

function netinfo() {
    echo "🌐 Network Information:"
    
    # Public IP
    if command -v curl >/dev/null 2>&1; then
        echo "Public IP: $(curl -s https://ipinfo.io/ip 2>/dev/null || echo 'Unable to fetch')"
    fi
    
    # Local IPs
    echo "Local IPs:"
    if [[ "$(uname)" == "Darwin" ]]; then
        ifconfig | grep -E 'inet [0-9]' | grep -v 127.0.0.1 | awk '{print "  " $2}'
    else
        ip addr show | grep -E 'inet [0-9]' | grep -v 127.0.0.1 | awk '{print "  " $2}' | cut -d/ -f1
    fi
    
    # DNS servers
    echo "DNS Servers:"
    if [[ -f /etc/resolv.conf ]]; then
        grep nameserver /etc/resolv.conf | awk '{print "  " $2}'
    fi
    
    # Open ports
    echo "Open ports:"
    lsof -i -P -n 2>/dev/null | grep LISTEN | awk '{print "  " $1 " - " $9}' | sort -u | head -10
}

function utils-help() {
    cat << 'EOF'
🛠️  General Utilities Quick Reference:

File Operations:
  mkcd <dir>     - Create and enter directory
  backup <file>  - Create timestamped backup
  extract <file> - Extract various archive formats
  findfile <name> - Find files by name
  finddir <name>  - Find directories by name
  findtext <text> - Search text in files

Network:
  myip          - Show public IP address
  localip       - Show local IP addresses
  serve [port]  - Start HTTP server (default: 8000)
  weather [city] - Show weather forecast

Text Processing:
  jsonformat    - Format/pretty-print JSON
  yamltojson    - Convert YAML to JSON
  urlencode     - URL encode string
  urldecode     - URL decode string
  hash <text>   - Generate hash (md5, sha1, sha256, sha512)
  encode <text> - Encode string (base64, url)
  decode <text> - Decode string (base64, url)

System:
  sysinfo       - System information
  diskusage     - Disk usage summary
  netinfo       - Network information
  colors        - Terminal color test

Utilities:
  calc <expr>   - Calculator
  genpass [len] - Generate password
  timer <sec>   - Countdown timer
  stopwatch     - Simple stopwatch
  qr <text>     - Generate QR code

Type 'aliases' to see all available aliases
Type 'functions' to see all available functions
EOF
}

# Brewfile management
alias brewsync="~/.dotfiles/bin/update-brewfile"
alias brewsync-dry="~/.dotfiles/bin/update-brewfile --dry-run"
alias brewsync-verbose="~/.dotfiles/bin/update-brewfile --verbose"

# Task runner shortcuts - consolidated
alias t="task"
alias tl="task --list"
alias th="task help"
alias tm="task maintain"  # The universal maintenance command
alias td="task doctor"
alias tu="task update"
alias tb="task backup"
alias ts="task sync"
alias tg="task git"

# Utility aliases loaded - use 'utils-help' for quick reference