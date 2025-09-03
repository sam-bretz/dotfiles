#!/usr/bin/env zsh
# ============================================================================
# Docker & Container Aliases - Enhanced Container Operations
# ============================================================================

# Docker basic shortcuts - note: 'd' might conflict with dirs alias
# Use 'docker' or 'dk' for docker to avoid conflicts
alias dk='docker'
alias dc='docker-compose'
alias dcp='docker-compose'

# Docker container operations
alias dps='docker ps'
alias dpsa='docker ps -a'
alias dstart='docker start'
alias dstop='docker stop'
alias drestart='docker restart'
alias dkill='docker kill'
alias drm='docker rm'
alias drmi='docker rmi'
alias dexec='docker exec -it'
alias drun='docker run --rm -it'
alias dlogs='docker logs'
alias dlogsf='docker logs -f'
alias dinspect='docker inspect'

# Docker image operations
alias dimages='docker images'
alias dpull='docker pull'
alias dpush='docker push'
alias dbuild='docker build'
alias dtag='docker tag'
alias dsave='docker save'
alias dload='docker load'
alias dhistory='docker history'

# Docker system operations
alias dinfo='docker info'
alias dversion='docker version'
alias ddf='docker system df'
alias dprune='docker system prune'
alias dprunea='docker system prune -a'
alias dprune-volumes='docker volume prune'
alias dprune-networks='docker network prune'

# Docker volume operations
alias dvolumes='docker volume ls'
alias dvolume-inspect='docker volume inspect'
alias dvolume-create='docker volume create'
alias dvolume-rm='docker volume rm'

# Docker network operations
alias dnetworks='docker network ls'
alias dnetwork-inspect='docker network inspect'
alias dnetwork-create='docker network create'
alias dnetwork-rm='docker network rm'

# Docker Compose shortcuts
alias dcu='docker-compose up'
alias dcud='docker-compose up -d'
alias dcd='docker-compose down'
alias dcr='docker-compose restart'
alias dcl='docker-compose logs'
alias dclf='docker-compose logs -f'
alias dcp='docker-compose ps'
alias dcpull='docker-compose pull'
alias dcbuild='docker-compose build'
alias dcrm='docker-compose rm'
alias dcstop='docker-compose stop'
alias dcstart='docker-compose start'
alias dcexec='docker-compose exec'
alias dcrun='docker-compose run --rm'

# Enhanced Docker functions
function dsh() {
    if [[ -z "$1" ]]; then
        echo "Usage: dsh <container-name-or-id> [shell]"
        echo "Available containers:"
        docker ps --format "table {{.Names}}\t{{.Image}}\t{{.Status}}"
        return 1
    fi
    
    local shell="${2:-bash}"
    echo "🐚 Accessing container: $1 with $shell"
    docker exec -it "$1" "$shell" || docker exec -it "$1" sh
}

function dstats() {
    if [[ -z "$1" ]]; then
        echo "📊 Docker system stats:"
        docker stats --no-stream
    else
        echo "📊 Stats for container: $1"
        docker stats --no-stream "$1"
    fi
}

function dclean() {
    echo "🧹 Docker cleanup options:"
    echo "1. Remove stopped containers"
    echo "2. Remove unused images"
    echo "3. Remove unused volumes"
    echo "4. Remove unused networks"
    echo "5. System prune (containers, networks, images)"
    echo "6. System prune ALL (including volumes)"
    echo "7. Full cleanup (everything)"
    echo ""
    echo "Choose option (1-7): "
    read -r choice
    
    case "$choice" in
        1)
            echo "🗑️  Removing stopped containers..."
            docker container prune -f
            ;;
        2)
            echo "🗑️  Removing unused images..."
            docker image prune -f
            ;;
        3)
            echo "🗑️  Removing unused volumes..."
            docker volume prune -f
            ;;
        4)
            echo "🗑️  Removing unused networks..."
            docker network prune -f
            ;;
        5)
            echo "🗑️  System prune (safe)..."
            docker system prune -f
            ;;
        6)
            echo "⚠️  System prune ALL (including volumes)..."
            docker system prune -af --volumes
            ;;
        7)
            echo "⚠️  FULL CLEANUP - This will remove EVERYTHING unused!"
            echo "Are you absolutely sure? (type 'yes' to confirm):"
            read -r confirm
            if [[ "$confirm" == "yes" ]]; then
                docker system prune -af --volumes
                docker container prune -f
                docker image prune -af
                docker volume prune -f
                docker network prune -f
                echo "✅ Full cleanup completed"
            else
                echo "Aborted."
            fi
            ;;
        *)
            echo "Invalid option"
            ;;
    esac
}

function dsize() {
    echo "💾 Docker disk usage:"
    docker system df -v
}

function dport() {
    if [[ -z "$1" ]]; then
        echo "Usage: dport <container-name-or-id>"
        echo "Shows port mappings for container"
        return 1
    fi
    
    docker port "$1"
}

function dip() {
    if [[ -z "$1" ]]; then
        echo "Usage: dip <container-name-or-id>"
        echo "Shows IP address of container"
        return 1
    fi
    
    docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' "$1"
}

function denv() {
    if [[ -z "$1" ]]; then
        echo "Usage: denv <container-name-or-id>"
        echo "Shows environment variables of container"
        return 1
    fi
    
    docker inspect -f '{{range .Config.Env}}{{println .}}{{end}}' "$1"
}

function dsearch() {
    if [[ -z "$1" ]]; then
        echo "Usage: dsearch <search-term>"
        echo "Search for Docker images on Docker Hub"
        return 1
    fi
    
    docker search "$1"
}

function dbackup() {
    if [[ -z "$1" ]] || [[ -z "$2" ]]; then
        echo "Usage: dbackup <container-name> <backup-file>"
        echo "Create a backup of a container"
        return 1
    fi
    
    echo "📦 Creating backup of $1..."
    docker commit "$1" "${1}-backup"
    docker save -o "$2" "${1}-backup"
    echo "✅ Backup saved to $2"
}

function drestore() {
    if [[ -z "$1" ]]; then
        echo "Usage: drestore <backup-file>"
        echo "Restore a container from backup"
        return 1
    fi
    
    echo "📦 Restoring from $1..."
    docker load -i "$1"
    echo "✅ Backup restored"
}

# Docker Compose enhanced functions
function dclog() {
    if [[ -z "$1" ]]; then
        echo "📋 All services logs:"
        docker-compose logs -f
    else
        echo "📋 Logs for service: $1"
        docker-compose logs -f "$1"
    fi
}

function dcsh() {
    if [[ -z "$1" ]]; then
        echo "Usage: dcsh <service-name> [shell]"
        echo "Available services:"
        docker-compose ps --services
        return 1
    fi
    
    local shell="${2:-bash}"
    echo "🐚 Accessing service: $1 with $shell"
    docker-compose exec "$1" "$shell" || docker-compose exec "$1" sh
}

function dcrestart() {
    if [[ -z "$1" ]]; then
        echo "🔄 Restarting all services..."
        docker-compose restart
    else
        echo "🔄 Restarting service: $1"
        docker-compose restart "$1"
    fi
}

function dcscale() {
    if [[ -z "$1" ]] || [[ -z "$2" ]]; then
        echo "Usage: dcscale <service> <count>"
        echo "Scale a service to specified number of replicas"
        return 1
    fi
    
    echo "⚖️  Scaling $1 to $2 replicas..."
    docker-compose up -d --scale "$1=$2"
}

# Development helpers
function ddev() {
    echo "🐳 Docker development helpers:"
    echo ""
    echo "Basic Commands:"
    echo "  dk           - docker (short alias)"
    echo "  dc           - docker-compose"
    echo "  dps          - Show running containers"
    echo "  dsh <name>   - Shell into container"
    echo "  dlogs <name> - Follow container logs"
    echo "  dstats       - Show container stats"
    echo ""
    echo "Compose Actions:"
    echo "  dcu          - Start services"
    echo "  dcud         - Start services (detached)"
    echo "  dcd          - Stop services"
    echo "  dcl          - Show logs"
    echo "  dcsh <svc>   - Shell into service"
    echo ""
    echo "Cleanup:"
    echo "  dclean       - Interactive cleanup"
    echo "  dprune       - System prune"
    echo ""
    echo "Info:"
    echo "  dsize        - Disk usage"
    echo "  dip <name>   - Container IP"
    echo "  dport <name> - Port mappings"
}

# Integration with modern tools
if command -v lazydocker >/dev/null 2>&1; then
    alias lzd='lazydocker'
    alias dockerui='lazydocker'
fi

if command -v dive >/dev/null 2>&1; then
    alias ddive='dive'
    function danalyze() {
        if [[ -z "$1" ]]; then
            echo "Usage: danalyze <image-name>"
            return 1
        fi
        echo "🔍 Analyzing image: $1"
        dive "$1"
    }
fi

if command -v ctop >/dev/null 2>&1; then
    alias dtop='ctop'
fi

# Docker buildx (multi-platform builds)
if docker buildx version >/dev/null 2>&1; then
    alias dbx='docker buildx'
    alias dbxbuild='docker buildx build'
    alias dbxls='docker buildx ls'
    
    function dbxsetup() {
        echo "🏗️  Setting up Docker Buildx..."
        docker buildx create --name multiarch --driver docker-container --use
        docker buildx inspect --bootstrap
        echo "✅ Buildx setup complete"
    }
fi

# Docker context management
alias dctx='docker context'
alias dctxls='docker context ls'
alias dctxuse='docker context use'

function dctxadd() {
    if [[ -z "$1" ]] || [[ -z "$2" ]]; then
        echo "Usage: dctxadd <name> <endpoint>"
        echo "Add a new Docker context"
        return 1
    fi
    
    docker context create "$1" --docker "host=$2"
}

# Docker aliases loaded - use 'ddev' for development helper guide