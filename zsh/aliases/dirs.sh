alias fairweather="cd ~/projects/fair-weather && v"
alias nvd='cd ~/.dotfiles/nvim/.config/nvim'
alias luad='~/.dotfiles/nvim/.config/nvim/lua/sambretz'
alias dot='cd ~/.dotfiles/ && v'
alias dotdir='cd ~/.dotfiles/'
alias nvp='cd ~/.dotfiles/nvim/.config/nvim/ && v' # nvim plugin dir
alias resume='cd ~/projects/resume && v'
alias todo='nvim $CLOUD_PATH/todo.md'

# AWS EC2 aliases (dynamic IP resolution)
alias sourcehub-ec2='~/code/sourceHubv2/scripts/aws-deploy/ec2-connect.sh connect'
alias sourcehub-ip='~/code/sourceHubv2/scripts/aws-deploy/ec2-connect.sh find'
alias sourcehub-deploy='~/code/sourceHubv2/scripts/aws-deploy/ec2-connect.sh deploy'
alias sourcehub-status='~/code/sourceHubv2/scripts/aws-deploy/ec2-connect.sh status'
# Database connection with secure password handling
# Set SOURCEHUB_DB_PASSWORD in your environment or use 1Password CLI
alias sourcehub-db='
if [ -n "$SOURCEHUB_DB_PASSWORD" ]; then
    PGPASSWORD="$SOURCEHUB_DB_PASSWORD" psql -h sourcehub-db.cfm0kcykeufs.us-east-2.rds.amazonaws.com -U sourcehub_admin -d sourcehub
elif command -v op >/dev/null 2>&1; then
    PGPASSWORD="$(op read "op://Personal/SourceHub Database/password")" psql -h sourcehub-db.cfm0kcykeufs.us-east-2.rds.amazonaws.com -U sourcehub_admin -d sourcehub
else
    echo "❌ Security Error: No secure password method available"
    echo "💡 Solutions:"
    echo "  1. Set environment variable: export SOURCEHUB_DB_PASSWORD=\"your_password\""
    echo "  2. Install 1Password CLI: brew install 1password-cli"
    echo "  3. Use .pgpass file for automatic authentication"
    return 1
fi'
