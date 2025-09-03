#!/usr/bin/env zsh
# ============================================================================
# Node.js & NPM Aliases - Enhanced Package Management & Development
# ============================================================================

# NPM basic shortcuts
alias n='npm'
alias ni='npm install'
alias nid='npm install --save-dev'
alias nig='npm install --global'
alias nu='npm uninstall'
alias nug='npm uninstall --global'
alias nup='npm update'
alias nci='npm ci'
alias nr='npm run'
alias nrs='npm run start'
alias nrd='npm run dev'
alias nrb='npm run build'
alias nrt='npm run test'
alias nrl='npm run lint'
alias nrf='npm run format'
alias ns='npm start'
alias nt='npm test'
alias nb='npm run build'
alias nw='npm run watch'
alias nv='npm version'
alias nls='npm list'
alias nlsg='npm list --global'
alias nout='npm outdated'
alias nau='npm audit'
alias nauf='npm audit fix'
alias ncc='npm cache clean --force'

# Yarn shortcuts (if available)
if command -v yarn >/dev/null 2>&1; then
    alias y='yarn'
    alias ya='yarn add'
    alias yad='yarn add --dev'
    alias yag='yarn global add'
    alias yr='yarn remove'
    alias yup='yarn upgrade'
    alias yi='yarn install'
    alias yif='yarn install --frozen-lockfile'
    alias ys='yarn start'
    alias yd='yarn dev'
    alias yb='yarn build'
    alias yt='yarn test'
    alias yl='yarn lint'
    alias yf='yarn format'
    alias yrun='yarn run'
    alias yout='yarn outdated'
    alias yau='yarn audit'
    alias ycc='yarn cache clean'
fi

# PNPM shortcuts (if available)
if command -v pnpm >/dev/null 2>&1; then
    alias p='pnpm'
    alias pi='pnpm install'
    alias pa='pnpm add'
    alias pad='pnpm add --save-dev'
    alias pag='pnpm add --global'
    alias pr='pnpm remove'
    alias pup='pnpm update'
    alias ps='pnpm start'
    alias pd='pnpm dev'
    alias pb='pnpm build'
    alias pt='pnpm test'
    alias pl='pnpm lint'
    alias pf='pnpm format'
    alias prun='pnpm run'
    alias pls='pnpm list'
    alias pout='pnpm outdated'
    alias pau='pnpm audit'
    alias pcc='pnpm store prune'
fi

# Bun shortcuts (if available)
if command -v bun >/dev/null 2>&1; then
    alias b='bun'
    alias bi='bun install'
    alias ba='bun add'
    alias bad='bun add --dev'
    alias bag='bun add --global'
    alias br='bun remove'
    alias bup='bun update'
    alias bs='bun start'
    alias bd='bun dev'
    alias bb='bun build'
    alias bt='bun test'
    alias brun='bun run'
    alias bx='bunx'
fi

# Node.js version management (NVM)
if [[ -s "$HOME/.nvm/nvm.sh" ]]; then
    alias nvm-ls='nvm list'
    alias nvm-use='nvm use'
    alias nvm-install='nvm install'
    alias nvm-current='nvm current'
    alias nvm-default='nvm alias default'
fi

# NPX shortcuts
alias nx='npx'
alias nxcra='npx create-react-app'
alias nxcna='npx create-next-app'
alias nxcva='npx create-vue-app'
alias nxcta='npx create-t3-app'
alias nxvite='npx create-vite'

# Enhanced Node.js functions
function ninfo() {
    echo "📦 Node.js Environment Info:"
    echo "Node.js: $(node --version 2>/dev/null || echo 'Not installed')"
    echo "NPM: $(npm --version 2>/dev/null || echo 'Not installed')"
    
    if command -v yarn >/dev/null 2>&1; then
        echo "Yarn: $(yarn --version)"
    fi
    
    if command -v pnpm >/dev/null 2>&1; then
        echo "PNPM: $(pnpm --version)"
    fi
    
    if command -v bun >/dev/null 2>&1; then
        echo "Bun: $(bun --version)"
    fi
    
    if [[ -s "$HOME/.nvm/nvm.sh" ]]; then
        echo "NVM: $(nvm --version 2>/dev/null || echo 'Available')"
    fi
    
    echo ""
    echo "Current directory package manager:"
    if [[ -f "bun.lockb" ]]; then
        echo "🥖 Bun (bun.lockb found)"
    elif [[ -f "pnpm-lock.yaml" ]]; then
        echo "🧶 PNPM (pnpm-lock.yaml found)"
    elif [[ -f "yarn.lock" ]]; then
        echo "🧶 Yarn (yarn.lock found)"
    elif [[ -f "package-lock.json" ]]; then
        echo "📦 NPM (package-lock.json found)"
    elif [[ -f "package.json" ]]; then
        echo "📄 Package.json found (no lock file)"
    else
        echo "❌ No package.json found"
    fi
}

function nscripts() {
    if [[ ! -f "package.json" ]]; then
        echo "❌ No package.json found in current directory"
        return 1
    fi
    
    echo "📜 Available scripts:"
    if command -v jq >/dev/null 2>&1; then
        jq -r '.scripts | to_entries[] | "  \(.key) - \(.value)"' package.json 2>/dev/null || {
            echo "⚠️  jq failed, showing raw scripts section:"
            grep -A 20 '"scripts"' package.json | grep -E '^\s*"[^"]+":' | sed 's/^\s*"//; s/":\s*"/ - /; s/",\?$//'
        }
    else
        echo "⚠️  Install jq for better formatting. Raw scripts:"
        grep -A 20 '"scripts"' package.json | grep -E '^\s*"[^"]+":' | sed 's/^\s*"//; s/":\s*"/ - /; s/",\?$//'
    fi
}

function ndeps() {
    if [[ ! -f "package.json" ]]; then
        echo "❌ No package.json found in current directory"
        return 1
    fi
    
    echo "📦 Package dependencies:"
    if command -v jq >/dev/null 2>&1; then
        echo ""
        echo "Production dependencies:"
        jq -r '.dependencies // {} | to_entries[] | "  \(.key): \(.value)"' package.json 2>/dev/null
        echo ""
        echo "Development dependencies:"
        jq -r '.devDependencies // {} | to_entries[] | "  \(.key): \(.value)"' package.json 2>/dev/null
        echo ""
        echo "Peer dependencies:"
        jq -r '.peerDependencies // {} | to_entries[] | "  \(.key): \(.value)"' package.json 2>/dev/null
    else
        echo "⚠️  Install jq for better formatting. Use 'cat package.json' for raw view."
    fi
}

function nclean() {
    echo "🧹 Node.js cleanup options:"
    echo "1. Remove node_modules"
    echo "2. Remove lock files"
    echo "3. Clear npm cache"
    echo "4. Full cleanup (all of the above)"
    echo "5. Reset and reinstall"
    echo ""
    echo "Choose option (1-5): "
    read -r choice
    
    case "$choice" in
        1)
            echo "🗑️  Removing node_modules..."
            rm -rf node_modules
            echo "✅ node_modules removed"
            ;;
        2)
            echo "🗑️  Removing lock files..."
            rm -f package-lock.json yarn.lock pnpm-lock.yaml bun.lockb
            echo "✅ Lock files removed"
            ;;
        3)
            echo "🗑️  Clearing npm cache..."
            npm cache clean --force
            if command -v yarn >/dev/null 2>&1; then
                yarn cache clean
            fi
            if command -v pnpm >/dev/null 2>&1; then
                pnpm store prune
            fi
            echo "✅ Caches cleared"
            ;;
        4)
            echo "🗑️  Full cleanup..."
            rm -rf node_modules
            rm -f package-lock.json yarn.lock pnpm-lock.yaml bun.lockb
            npm cache clean --force
            if command -v yarn >/dev/null 2>&1; then
                yarn cache clean
            fi
            if command -v pnpm >/dev/null 2>&1; then
                pnpm store prune
            fi
            echo "✅ Full cleanup completed"
            ;;
        5)
            echo "🔄 Reset and reinstall..."
            rm -rf node_modules
            rm -f package-lock.json yarn.lock pnpm-lock.yaml bun.lockb
            npm cache clean --force
            
            # Detect and use appropriate package manager
            if [[ -f "bun.lockb.backup" ]] || command -v bun >/dev/null 2>&1; then
                echo "Installing with Bun..."
                bun install
            elif [[ -f "pnpm-lock.yaml.backup" ]] || command -v pnpm >/dev/null 2>&1; then
                echo "Installing with PNPM..."
                pnpm install
            elif [[ -f "yarn.lock.backup" ]] || command -v yarn >/dev/null 2>&1; then
                echo "Installing with Yarn..."
                yarn install
            else
                echo "Installing with NPM..."
                npm install
            fi
            echo "✅ Reset and reinstall completed"
            ;;
        *)
            echo "Invalid option"
            ;;
    esac
}

function ndev() {
    echo "🚀 Node.js development helpers:"
    echo ""
    echo "Package Management:"
    echo "  ni           - Install dependencies"
    echo "  nid          - Install dev dependencies"
    echo "  nu           - Uninstall packages"
    echo "  nup          - Update packages"
    echo "  nout         - Check outdated packages"
    echo ""
    echo "Scripts:"
    echo "  nrs          - Start development server"
    echo "  nrb          - Build project"
    echo "  nrt          - Run tests"
    echo "  nrl          - Run linter"
    echo ""
    echo "Tools:"
    echo "  ninfo        - Environment information"
    echo "  nscripts     - Show available scripts"
    echo "  ndeps        - Show dependencies"
    echo "  nclean       - Interactive cleanup"
    echo ""
    echo "Quick Actions:"
    echo "  nx <pkg>     - Run package with npx"
    echo "  nxcra <name> - Create React app"
    echo "  nxvite <name>- Create Vite project"
}

function ncheck() {
    if [[ ! -f "package.json" ]]; then
        echo "❌ No package.json found in current directory"
        return 1
    fi
    
    echo "🔍 Project health check:"
    echo ""
    
    # Check for security vulnerabilities
    if command -v npm >/dev/null 2>&1; then
        echo "🛡️  Security audit:"
        npm audit --audit-level moderate 2>/dev/null || echo "⚠️  Vulnerabilities found or audit failed"
        echo ""
    fi
    
    # Check for outdated packages
    echo "📅 Outdated packages:"
    npm outdated --depth=0 2>/dev/null || echo "✅ All packages up to date"
    echo ""
    
    # Check bundle size (if webpack-bundle-analyzer is available)
    if command -v webpack-bundle-analyzer >/dev/null 2>&1 && [[ -d "dist" ]] || [[ -d "build" ]]; then
        echo "📊 Bundle analysis available - run 'npx webpack-bundle-analyzer dist' or similar"
        echo ""
    fi
    
    # Check for common issues
    echo "🔧 Common issues:"
    if [[ -f "node_modules" ]] && [[ ! -d "node_modules" ]]; then
        echo "⚠️  node_modules exists but is not a directory"
    fi
    
    if [[ -f "package-lock.json" ]] && [[ -f "yarn.lock" ]]; then
        echo "⚠️  Both package-lock.json and yarn.lock found"
    fi
    
    if [[ ! -f ".gitignore" ]] || ! grep -q "node_modules" .gitignore 2>/dev/null; then
        echo "⚠️  node_modules might not be gitignored"
    fi
    
    echo "✅ Health check completed"
}

function nsize() {
    if [[ ! -d "node_modules" ]]; then
        echo "❌ node_modules directory not found"
        return 1
    fi
    
    echo "📊 Project size analysis:"
    echo ""
    
    if command -v dust >/dev/null 2>&1; then
        dust node_modules --depth 1 | head -20
    elif command -v du >/dev/null 2>&1; then
        du -sh node_modules/* 2>/dev/null | sort -hr | head -20
    else
        ls -la node_modules/
    fi
    
    echo ""
    echo "💾 Total node_modules size:"
    if command -v dust >/dev/null 2>&1; then
        dust -s node_modules
    else
        du -sh node_modules 2>/dev/null || echo "Unable to calculate size"
    fi
}

function nbench() {
    if [[ -z "$1" ]]; then
        echo "Usage: nbench <command> [iterations]"
        echo "Benchmark a npm script or command"
        return 1
    fi
    
    local command="$1"
    local iterations="${2:-5}"
    
    if command -v hyperfine >/dev/null 2>&1; then
        echo "🏃 Benchmarking: $command"
        hyperfine --warmup 1 --runs "$iterations" "npm run $command"
    else
        echo "⚠️  Install hyperfine for better benchmarking"
        echo "Running simple time test..."
        time npm run "$command"
    fi
}

# Package manager detection and switching
function nswitch() {
    local manager="$1"
    
    if [[ -z "$manager" ]]; then
        echo "Usage: nswitch <npm|yarn|pnpm|bun>"
        echo "Switch package manager for current project"
        return 1
    fi
    
    case "$manager" in
        npm)
            rm -f yarn.lock pnpm-lock.yaml bun.lockb
            npm install
            echo "✅ Switched to NPM"
            ;;
        yarn)
            if ! command -v yarn >/dev/null 2>&1; then
                echo "❌ Yarn not installed"
                return 1
            fi
            rm -f package-lock.json pnpm-lock.yaml bun.lockb
            yarn install
            echo "✅ Switched to Yarn"
            ;;
        pnpm)
            if ! command -v pnpm >/dev/null 2>&1; then
                echo "❌ PNPM not installed"
                return 1
            fi
            rm -f package-lock.json yarn.lock bun.lockb
            pnpm install
            echo "✅ Switched to PNPM"
            ;;
        bun)
            if ! command -v bun >/dev/null 2>&1; then
                echo "❌ Bun not installed"
                return 1
            fi
            rm -f package-lock.json yarn.lock pnpm-lock.yaml
            bun install
            echo "✅ Switched to Bun"
            ;;
        *)
            echo "❌ Unknown package manager: $manager"
            echo "Available: npm, yarn, pnpm, bun"
            ;;
    esac
}

# Integration with modern tools
if command -v npm-check-updates >/dev/null 2>&1; then
    alias ncu='npm-check-updates'
    alias ncuu='npm-check-updates -u'
fi

if command -v npm-check >/dev/null 2>&1; then
    alias ncheck-interactive='npm-check'
fi

# Node.js aliases loaded - use 'ndev' for development helper guide