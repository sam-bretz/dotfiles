# Install autoload plugin
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim


ln -s ~/dotfiles/config/vim/.vimrc ~/.vimrc
ln -s ~/dotfiles/config/vim/autoload ~/.vim/autoload

vim +PlugInstall +qall

