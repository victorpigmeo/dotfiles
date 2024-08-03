#!/bin/sh

sudo apt install zsh

cat /etc/shells

chsh

DOTFILESDIR=${HOME}/.dotfiles

${DOTFILESDIR}/scripts/./install-fzf.sh
${DOTFILESDIR}/scripts/./install-oh-my-zsh.sh
ln -sf ${DOTFILESDIR}/.oh-my-zsh/custom/aliases.zsh ~/.oh-my-zsh/custom/aliases.zsh
ln -sf ${DOTFILESDIR}/.oh-my-zsh/custom/config.zsh ~/.oh-my-zsh/custom/config.zsh
${DOTFILESDIR}/scripts/./install-oh-my-zsh-plugins.sh
ln -sf ${DOTFILESDIR}/.p10k.zsh ~/.p10k.zsh
ln -sf ${DOTFILESDIR}/.fzf.zsh ~/.fzf.zsh
mv ~/.zshrc ~/.zshrc_before_dotfiles
ln -sf ${DOTFILESDIR}/.zshrc ~/.zshrc
