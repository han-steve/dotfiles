#!/bin/zsh

# First, install dev tools
xcode-select --install

# fonts
cp fonts/Source\ Code\ Pro\ for\ Powerline.otf $HOME/Library/Fonts/

# Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
zsh brew/brew.sh;

# Zsh
zsh zsh/zsh.sh

# Tmux
zsh tmux/tmux.sh

# nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.37.2/install.sh | zsh;
source ~/.zshrc;
nvm install node;

# Git
zsh git/git.sh

# Nvim
zsh nvim/nvim.sh

# VSCode
zsh vscode/vscode.sh

# Python
zsh python/python.sh

# Conda
zsh conda/conda.sh

