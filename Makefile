main:
	@echo "Creating symlinks for dotfiles"
	@find ~  -maxdepth 1 -type l -delete; 
	@ln -s ~/dotfiles ~/.config
	@ln -s ~/dotfiles/tmux/tmux.conf ~/.tmux.conf
	-@ln -s ~/dotfiles/tmux ~/.tmux
	-@ln -s ~/dotfiles/.* ~
	@rm -rf ~/.git

set-key-repeat:
	defaults write -g InitialKeyRepeat -int 10 # normal minimum is 15 (225 ms)
	defaults write -g KeyRepeat -int 1 # normal minimum is 2 (30 ms)
	defaults write -g ApplePressAndHoldEnabled -bool false

name:
	sudo scutil --set HostName "THEO-M1"

install:
	$(MAKE) main
	$(MAKE) set-key-repeat
	$(MAKE) name
	echo "Installing Homebrew"
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	test -d ~/dotfiles/alacritty/catppuccin || git clone https://github.com/catppuccin/alacritty.git ~/dotfiles/alacritty/catppuccin
	test -d ~/dotfiles/.tmux/plugins/tpm || git clone https://github.com/tmux-plugins/tpm ~/dotfiles/.tmux/plugins/tpm	
