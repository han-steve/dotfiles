#!/bin/zsh

# Vim Plug
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

# link config file
mkdir -p ~/.config/nvim
ln -sf $(pwd)/nvim/init.vim ~/.config/nvim/init.vim

# Now we will install the plug ins 
# nvim -c PlugInstall (this doesn't work)
