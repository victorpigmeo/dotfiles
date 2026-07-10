DOTFILESDIR=${HOME}/.dotfiles

# ZSH

mv ~/.zshrc ~/.zshrc_before_dotfiles
ln -sf ${DOTFILESDIR}/.zshrc ~/.zshrc 