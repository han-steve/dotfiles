#!/bin/zsh

# Vim Plug
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

# Now we will install the plug ins manually 

# link config file
mkdir ~/.config/nvim
ln -sfh $(pwd)/nvim/init.vim ~/.config/nvim/init.vim
