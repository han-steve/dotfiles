#!/bin/zsh

# fonts
cp fonts/Source\ Code\ Pro\ for\ Powerline.otf $HOME/Library/Fonts/

# Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
zsh brew/brew.sh;

# Zsh
zsh zsh/zsh.sh
