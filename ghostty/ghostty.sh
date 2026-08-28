#!/bin/zsh

if [[ "$OSTYPE" == "darwin"* ]]; then
	mkdir -p "$HOME/Library/Application Support/com.mitchellh.ghostty"
	ln -sfh $(pwd)/ghostty/config "$HOME/Library/Application Support/com.mitchellh.ghostty/config"
else
	mkdir -p $HOME/.config/ghostty
	ln -sfn $(pwd)/ghostty/config $HOME/.config/ghostty/config
fi
