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
	#sudo scutil --set HostName "M1"

install:
	brew install \
	zoxide \
	nvim \
	tmux \
	fzf \
	#gh \
	git \
	#iproute2mac \
	koekeishiya/formulae/skhd \
	koekeishiya/formulae/yabai \
	neovim \
	#pdfgrep \
	openjdk@11 \
	python@3.10 \
	reattach-to-user-namespace \
	tree \
	#walk \
	yqrashawn/goku/goku  \
	node \
	anaconda \
	#bkt \
	bash \
	coreutils \
	findutils # xargs -d
	#
	#brew tap arl/arl
	#brew install gitmux
	#
	brew tap epk/epk
	brew install --cask font-sf-mono-nerd-font
	test -d ~/dotfiles/alacritty/catppuccin || git clone https://github.com/catppuccin/alacritty.git ~/dotfiles/alacritty/catppuccin
	test -d ~/dotfiles/.tmux/plugins/tpm || git clone https://github.com/tmux-plugins/tpm ~/dotfiles/.tmux/plugins/tpm	
	#
	git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
	#
	brew tap FelixKratz/formulae
	brew install borders
	#
	brew install --cask \
	#raycast \
	alacritty \
	appcleaner \
	karabiner-elements \
	#fig \
	visual-studio-code \
	#stats \
	#messenger \
	#docker \
	#shortcat \
	#slack \
	#spotify \
	#phpstorm 
	#
	#python3 -m pip install aw-client
	#
	# volar dependencies for vuen 
	#npm install -g @vue/language-server
	#npm install -g typescript
	#npm install -g typescript-language-server


