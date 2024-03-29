#!/bin/zsh

# oh-my-zsh
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# plugins
git clone https://github.com/agkozak/zsh-z ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-z
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-history-substring-search ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-history-substring-search
git clone https://github.com/denysdovhan/spaceship-prompt.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/spaceship-prompt --depth=1
ln -s ${ZSH_CUTOM:-~/.oh-my-zsh/custom}/themes/spaceship-prompt/spaceship.zsh-theme ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/spaceship.zsh-theme


# base16 color theme
git clone https://github.com/chriskempson/base16-shell.git ~/.config/base16-shell


if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    ln -nfs $(pwd)/zsh/.ubuntu_zshrc $HOME/.zshrc
	chsh -s /bin/zsh
elif [[ "$OSTYPE" == "darwin"* ]]; then
    ln -nfs $(pwd)/zsh/.zshrc $HOME/.zshrc
	if [[ $(uname -m) == 'arm64' ]]; then
		sudo dscl . -create /Users/$USER UserShell /opt/homebrew/bin/zsh
	elif [[ $(uname -m) == 'x86_64' ]]; then
		sudo dscl . -create /Users/$USER UserShell /usr/local/bin/zsh
	else
		echo "ERROR: not intel or M1"
	fi
else 
	echo "ERROR: unknown OS"
fi
