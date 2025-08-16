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
alias sourcehub-db='PGPASSWORD=SourceHub2024SecurePassword psql -h sourcehub-db.cfm0kcykeufs.us-east-2.rds.amazonaws.com -U sourcehub_admin -d sourcehub'
