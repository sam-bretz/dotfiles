# ZSH Alias Organization

This directory contains organized shell aliases for enhanced productivity and development workflow.

## File Structure

### Core Files

| File | Purpose | Key Features |
|------|---------|-------------|
| `utils.sh` | General system utilities | File ops, network tools, text processing |
| `shorthand.sh` | Quick shortcuts | Editor shortcuts, basic commands |
| `modern-cli.sh` | Modern CLI tool integrations | eza, bat, fd, rg, zoxide, atuin |
| `configs.sh` | Configuration file shortcuts | Quick access to config files |
| `dirs.sh` | Directory & project navigation | Project shortcuts, AWS connections |

### Development Tools

| File | Purpose | Key Features |
|------|---------|-------------|
| `git.sh` | Git workflow enhancements | Advanced git aliases, worktree management |
| `docker.sh` | Container operations | Docker/Compose shortcuts, management functions |
| `npm.sh` | Node.js package management | NPM/Yarn/PNPM/Bun shortcuts |

## Usage

### Help Commands
- `utils-help` - General utilities reference
- `git-help` - Git workflow guide  
- `ddev` - Docker development helpers
- `ndev` - Node.js development helpers

### Key Features

#### Smart Navigation
- `..`, `...`, `....` - Parent directory navigation
- `1-9` - Directory stack navigation (`d` to see stack)
- `z <path>` - Smart directory jumping (zoxide)

#### Enhanced File Operations  
- `ls`, `ll`, `la` - Enhanced listing (eza/lsd fallback)
- `cat` - Syntax highlighting (bat)
- `grep` - Better search (ripgrep)
- `find` - Modern file finder (fd)

#### Development Workflow
- `gs`, `ga`, `gc` - Git shortcuts
- `dk`, `dc` - Docker shortcuts (dk=docker, dc=compose)  
- `ni`, `nr`, `nb` - NPM shortcuts
- `dcu`, `dcd` - Compose up/down
- `gwt` - Git worktree management

#### System Utilities
- `serve` - HTTP server
- `extract` - Universal archive extractor
- `backup` - Timestamped backups
- `weather` - Weather forecast
- `myip` - Public IP address
- `sysinfo` - System information

## Alias Conflicts Resolved

- `d` - Directory stack (dirs) vs Docker conflict resolved (use `dk` for docker)
- `gs` - Git status (moved to git.sh, removed from shorthand.sh)
- Directory navigation - Centralized in utils.sh
- Modern CLI tools - Organized with fallbacks in modern-cli.sh

## Loading Order

Aliases are loaded in dependency order:
1. `utils.sh` - Base utilities
2. `shorthand.sh` - Quick shortcuts
3. `modern-cli.sh` - CLI tool replacements
4. `configs.sh` - Configuration shortcuts
5. `dirs.sh` - Directory shortcuts
6. `git.sh` - Git enhancements
7. `docker.sh` - Container operations
8. `npm.sh` - Node.js tools

## Backward Compatibility

All existing functionality is preserved while adding new organized structure. The loading mechanism provides feedback on missing files and graceful degradation.

## Adding New Aliases

- **System utilities** → `utils.sh`
- **Quick shortcuts** → `shorthand.sh` 
- **Tool-specific** → Appropriate tool file
- **Project navigation** → `dirs.sh`
- **Config access** → `configs.sh`

## Modern Tool Integration

The system automatically detects and configures modern CLI tools:
- **eza/lsd** → Enhanced ls
- **bat** → Syntax highlighting
- **fd** → Better find
- **ripgrep** → Better grep
- **zoxide** → Smart cd
- **atuin** → Smart history
- **lazygit** → Git TUI
- **lazydocker** → Docker TUI