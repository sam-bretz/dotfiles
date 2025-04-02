# Install Fonts
brew tap homebrew/cask-fonts

brew install --cask font-fira-code-nerd-font
brew install --cask font-jetbrains-mono
brew install --cask font-hack
brew install --cask font-iosevka
brew install --cask font-inconsolata

# Install Brewfile packages
brew bundle --file=~/.dotfiles/brew/Brewfile
