#!/bin/zsh

git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
ln -sfn $(pwd)/tmux/.tmux.conf $HOME/.tmux.conf
