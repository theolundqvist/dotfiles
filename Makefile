main:
	@echo "Creating symlinks for dotfiles"
	@find $HOME -maxdepth 1 -type l -delete; ln -s $CONF/.* $HOME
