main:
	@echo "Creating symlinks for dotfiles"
	@find ~  -maxdepth 1 -type l -delete; 
	@ln -s ~/dotfiles ~/.config
	@ln -s ~/dotfiles/tmux/tmux.conf ~/.tmux.conf
	@ln -s ~/dotfiles/.* ~

install:
	brew install \
	zoxide \
	nvim \
	tmux \
	esolitos/ipa/sshpass \
	fzf \
	gh \
	git \
	iproute2mac \
	koekeishiya/formulae/skhd \
	koekeishiya/formulae/yabai \
	neovim \
	pdfgrep \
	openjdk@11 \
	python@3.10 \
	reattach-to-user-namespace \
	tree \
	walk \
	yqrashawn/goku/goku 
	
	brew tap epk/epk
	brew install --cask font-sf-mono-nerd-font
	test -d ~/dotfiles/alacritty/catppuccin || git clone https://github.com/catppuccin/alacritty.git ~/dotfiles/alacritty/catppuccin
	test -d ~/dotfiles/.tmux/plugins/tpm || git clone https://github.com/tmux-plugins/tpm ~/dotfiles/.tmux/plugins/tpm	

	brew install --cask \
	alacritty \
	appcleaner \
	discord \
	fig \
	spotify \
	visual-studio-code \
	stats \
	messenger \
	docker \
	karabiner-elements
