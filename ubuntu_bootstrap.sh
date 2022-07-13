#!/bin/zsh

# install packages
sudo apt install neovim
sudo apt install zsh
sudo apt install tmux

# fonts
mkdir -p $HOME/.fonts
cp fonts/Source\ Code\ Pro\ for\ Powerline.otf $HOME/.fonts/

# Zsh
zsh zsh/zsh.sh

# Tmux
zsh tmux/tmux.sh

# nvm
#curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.37.2/install.sh | zsh;
#source ~/.zshrc;
#nvm install node;

# Git
#zsh git/git.sh

# Nvim
zsh nvim/nvim.sh

# VSCode - I don't need this anymore since I'm using vscode settings sync
# zsh vscode/vscode.sh 

# Python
# zsh python/python.sh

# Conda - not using it since I choose to do it manually
# zsh conda/conda.sh

