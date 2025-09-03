#!/usr/bin/env zsh
# ============================================================================
# Git Aliases and Functions - Enhanced Productivity
# ============================================================================

# Basic Git shortcuts that complement the .gitconfig aliases
alias g='git'
alias gs='git status'
alias ga='git add'
alias gaa='git add --all'
alias gau='git add --update'
alias gap='git add --patch'
alias gb='git branch'
alias gba='git branch --all'
alias gbd='git branch --delete'
alias gbD='git branch --delete --force'
alias gc='git commit'
alias gcm='git commit --message'
alias gca='git commit --all'
alias gcam='git commit --all --message'
alias gco='git checkout'
alias gcob='git checkout -b'
alias gcom='git checkout main'
alias gcod='git checkout develop'
alias gd='git diff'
alias gdc='git diff --cached'
alias gdw='git diff --word-diff'
alias gf='git fetch'
alias gfa='git fetch --all'
alias gl='git log --oneline --decorate --graph'
alias gla='git log --oneline --decorate --graph --all'
alias gm='git merge'
alias gp='git push'
alias gpf='git push --force-with-lease'
alias gpl='git pull'
alias gr='git remote'
alias grv='git remote --verbose'
alias gra='git remote add'
alias grr='git remote remove'
alias gru='git remote set-url'
alias grs='git reset'
alias grsh='git reset --hard'
alias grss='git reset --soft'
alias gst='git stash'
alias gstp='git stash pop'
alias gstl='git stash list'
alias gsta='git stash apply'
alias gstd='git stash drop'
alias gt='git tag'

# Advanced Git functions
function git_current_branch() {
    git branch 2>/dev/null | grep '^*' | colrm 1 2
}

function git_is_clean() {
    [[ -z "$(git status --porcelain 2>/dev/null)" ]]
}

function git_has_upstream() {
    git rev-parse --abbrev-ref @{upstream} >/dev/null 2>&1
}

# Quick commit with timestamp
function gct() {
    local message="${1:-"Quick commit $(date '+%Y-%m-%d %H:%M:%S')"}"
    git add . && git commit -m "$message"
}

# Git log with custom format
function glog() {
    git log --graph --pretty=format:'%Cred%h%Creset - %C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative "$@"
}

# Show git status with branch info
function gstat() {
    echo "🌿 Current branch: $(git_current_branch)"
    if git_has_upstream; then
        echo "📡 Upstream: $(git rev-parse --abbrev-ref @{upstream})"
    fi
    echo ""
    git status --short --branch
}

# Safe force push
function gpff() {
    local branch=$(git_current_branch)
    echo "⚠️  Force pushing to branch: $branch"
    echo "Are you sure? (y/N)"
    read -r response
    if [[ "$response" =~ ^[Yy]$ ]]; then
        git push --force-with-lease origin "$branch"
    else
        echo "Aborted."
    fi
}

# Create and switch to new branch
function gnb() {
    if [[ -z "$1" ]]; then
        echo "Usage: gnb <branch-name>"
        return 1
    fi
    git checkout -b "$1"
}

# Delete merged branches (interactive)
function gclean() {
    local merged_branches=$(git branch --merged main | grep -v '^\*\|main\|master\|develop')
    
    if [[ -z "$merged_branches" ]]; then
        echo "✅ No merged branches to delete"
        return 0
    fi
    
    echo "🗑️  The following branches will be deleted:"
    echo "$merged_branches"
    echo ""
    echo "Continue? (y/N)"
    read -r response
    
    if [[ "$response" =~ ^[Yy]$ ]]; then
        echo "$merged_branches" | xargs -n 1 git branch -d
        echo "✅ Cleaned up merged branches"
    else
        echo "Aborted."
    fi
}

# Git worktree enhanced functions
function gwt() {
    if [[ -z "$1" ]]; then
        echo "Usage: gwt <branch-name> [base-branch]"
        echo "Creates a new worktree for the given branch"
        return 1
    fi
    
    local branch="$1"
    local base="${2:-main}"
    local repo_name=$(basename $(git rev-parse --show-toplevel))
    local worktree_path="../${repo_name}-${branch}"
    
    echo "📁 Creating worktree: $worktree_path"
    echo "🌿 Branch: $branch (from $base)"
    
    git fetch origin "$base"
    git worktree add -b "$branch" "$worktree_path" "origin/$base"
    
    if [[ -d "$worktree_path" ]]; then
        echo "✅ Worktree created successfully"
        echo "💡 To navigate: cd $worktree_path"
        echo "💡 To clean up later: gwt-rm $branch"
    fi
}

# Remove worktree and branch
function gwt-rm() {
    if [[ -z "$1" ]]; then
        echo "Usage: gwt-rm <branch-name>"
        return 1
    fi
    
    local branch="$1"
    local repo_name=$(basename $(git rev-parse --show-toplevel))
    local worktree_path="../${repo_name}-${branch}"
    
    echo "🗑️  Removing worktree: $worktree_path"
    echo "🌿 Branch: $branch"
    
    if git worktree remove "$worktree_path"; then
        git branch -D "$branch" 2>/dev/null
        echo "✅ Worktree and branch removed"
    else
        echo "❌ Failed to remove worktree"
    fi
}

# List all worktrees with status
function gwt-list() {
    echo "📁 Git Worktrees:"
    git worktree list | while IFS= read -r line; do
        local path=$(echo "$line" | awk '{print $1}')
        local branch=$(echo "$line" | awk '{print $2}')
        local commit=$(echo "$line" | awk '{print $3}')
        
        if [[ "$branch" == "[$(git_current_branch)]" ]]; then
            echo "👉 $line (current)"
        else
            echo "   $line"
        fi
    done
}

# Show git log with files changed
function glogf() {
    git log --oneline --name-status "$@"
}

# Interactive rebase helper
function gri() {
    local commits="${1:-10}"
    git rebase -i HEAD~"$commits"
}

# Squash last N commits
function gsq() {
    if [[ -z "$1" ]]; then
        echo "Usage: gsq <number-of-commits>"
        return 1
    fi
    git reset --soft HEAD~"$1"
    git commit
}

# Show commits not yet pushed
function gunpushed() {
    local branch=$(git_current_branch)
    git log origin/"$branch".."$branch" --oneline
}

# Show commits not yet pulled
function gunpulled() {
    local branch=$(git_current_branch)
    git fetch
    git log "$branch"..origin/"$branch" --oneline
}

# Git blame with better formatting
function gblame() {
    git blame -w -C -C -C "$@"
}

# Search git history
function gsearch() {
    if [[ -z "$1" ]]; then
        echo "Usage: gsearch <search-term>"
        return 1
    fi
    git log -S"$1" --oneline
}

# Show files in last commit
function glast() {
    git show --name-only HEAD
}

# Undo last commit (keep changes)
function gundo() {
    git reset --soft HEAD~1
}

# Create patch from commits
function gpatch() {
    local start="${1:-HEAD~1}"
    local end="${2:-HEAD}"
    git format-patch "$start".."$end"
}

# Apply patch
function gapply() {
    if [[ -z "$1" ]]; then
        echo "Usage: gapply <patch-file>"
        return 1
    fi
    git apply "$1"
}

# Show git aliases
function galias() {
    git config --get-regexp '^alias\.' | sed 's/alias\.//' | sort
}

# Quick sync with upstream
function gsync() {
    local branch=$(git_current_branch)
    local upstream="origin/${2:-main}"
    
    echo "🔄 Syncing $branch with $upstream"
    
    if ! git_is_clean; then
        echo "⚠️  Working directory not clean. Stashing changes..."
        git stash push -m "Auto-stash before sync"
        local stashed=true
    fi
    
    git fetch origin
    git rebase "$upstream"
    
    if [[ "$stashed" == "true" ]]; then
        echo "🔄 Applying stashed changes..."
        git stash pop
    fi
    
    echo "✅ Sync complete"
}

# Enhanced git status with emojis
function gss() {
    local status_output=$(git status --porcelain)
    
    if [[ -z "$status_output" ]]; then
        echo "✨ Working directory clean"
        return 0
    fi
    
    echo "📊 Git Status:"
    echo "$status_output" | while IFS= read -r line; do
        local status="${line:0:2}"
        local file="${line:3}"
        
        case "$status" in
            "M ") echo "📝 Modified:   $file" ;;
            " M") echo "✏️  Modified:   $file (unstaged)" ;;
            "A ") echo "➕ Added:      $file" ;;
            "D ") echo "➖ Deleted:    $file" ;;
            " D") echo "🗑️  Deleted:    $file (unstaged)" ;;
            "R ") echo "🔄 Renamed:    $file" ;;
            "??") echo "❓ Untracked:  $file" ;;
            "!!") echo "🚫 Ignored:    $file" ;;
            *)   echo "❔ $status:     $file" ;;
        esac
    done
}

# Git commit with conventional commit format
function gcc() {
    local type="$1"
    local scope="$2"
    local message="$3"
    
    if [[ -z "$type" ]] || [[ -z "$message" ]]; then
        echo "Usage: gcc <type> [scope] <message>"
        echo "Types: feat, fix, docs, style, refactor, perf, test, chore"
        return 1
    fi
    
    local commit_msg="$type"
    if [[ -n "$scope" ]] && [[ "$scope" != "$message" ]]; then
        commit_msg="${commit_msg}(${scope})"
    fi
    commit_msg="${commit_msg}: ${message}"
    
    git commit -m "$commit_msg"
}

# Conventional commit shortcuts
alias gfeat='gcc feat'
alias gfix='gcc fix'
alias gdocs='gcc docs'
alias gstyle='gcc style'
alias grefactor='gcc refactor'
alias gperf='gcc perf'
alias gtest='gcc test'
alias gchore='gcc chore'

# Git hooks
function ghook() {
    local hook_name="$1"
    local hooks_dir="$(git rev-parse --git-dir)/hooks"
    
    if [[ -z "$hook_name" ]]; then
        echo "Available hooks:"
        ls "$hooks_dir" 2>/dev/null | grep -v '\.sample$' || echo "No hooks installed"
        return 0
    fi
    
    local hook_file="$hooks_dir/$hook_name"
    if [[ -f "$hook_file" ]]; then
        cat "$hook_file"
    else
        echo "Hook $hook_name not found"
    fi
}

# Git maintenance
function gmaint() {
    echo "🧹 Running git maintenance..."
    git gc --prune=now
    git remote prune origin
    echo "✅ Maintenance complete"
}

# Modern git aliases for compatibility with modern tools
if command -v delta >/dev/null 2>&1; then
    alias gd='git diff'
    alias gds='git diff --staged'
fi

if command -v lazygit >/dev/null 2>&1; then
    alias lg='lazygit'
fi

if command -v gh >/dev/null 2>&1; then
    alias gpr='gh pr create'
    alias gprs='gh pr status'
    alias gprv='gh pr view'
    alias gprm='gh pr merge'
    alias gissue='gh issue create'
    alias gissues='gh issue list'
fi

if command -v gitui >/dev/null 2>&1; then
    alias gu='gitui'
fi

# Git flow shortcuts (if git-flow is installed)
if command -v git-flow >/dev/null 2>&1; then
    alias gfi='git flow init'
    alias gff='git flow feature'
    alias gffs='git flow feature start'
    alias gfff='git flow feature finish'
    alias gfr='git flow release'
    alias gfrs='git flow release start'
    alias gfrf='git flow release finish'
    alias gfh='git flow hotfix'
    alias gfhs='git flow hotfix start'
    alias gfhf='git flow hotfix finish'
fi

# Help function
function git-help() {
    cat << 'EOF'
🚀 Enhanced Git Aliases & Functions

Basic Commands:
  g         - git
  gs/gss    - git status (gss with emojis)
  ga        - git add
  gc/gcm    - git commit
  gco       - git checkout
  gb        - git branch
  gd        - git diff
  gl        - git log
  gp        - git push
  gpl       - git pull

Enhanced Functions:
  gct       - Quick commit with timestamp
  gnb       - Create new branch
  gclean    - Delete merged branches
  gwt       - Create worktree
  gwt-rm    - Remove worktree
  gwt-list  - List worktrees
  gsync     - Sync with upstream
  gri       - Interactive rebase
  gsq       - Squash commits
  
Conventional Commits:
  gcc       - Conventional commit format
  gfeat     - feat: commit
  gfix      - fix: commit
  
Tools Integration:
  lg        - LazyGit (if installed)
  gu        - GitUI (if installed)
  gpr       - GitHub PR (if gh installed)

Type 'galias' to see all git aliases
EOF
}

# Git aliases loaded - use 'git-help' for usage guide