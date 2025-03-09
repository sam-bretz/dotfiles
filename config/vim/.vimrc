call plug#begin('~/.vim/plugged')

" List of plugins
Plug 'preservim/nerdtree'           " File system explorer
Plug 'vim-airline/vim-airline'      " Enhanced status line
Plug 'tpope/vim-surround'           " Surround text manipulation
Plug 'junegunn/fzf.vim'             " Fuzzy finder integration
Plug 'tpope/vim-fugitive'           " Git wrapper
Plug 'dense-analysis/ale'           " Asynchronous linting
Plug 'tpope/vim-commentary'         " Easy commenting
Plug 'airblade/vim-gitgutter'       " Git diff markers
Plug 'altercation/vim-colors-solarized' " Solarized color scheme

call plug#end()



" Automatically install plugins if not already installed
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

