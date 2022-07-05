#!/usr/bin/env bash

DOTFILESDIR=${HOME}/.dotfiles

${DOTFILESDIR}/scripts/./install-fzf.sh
${DOTFILESDIR}/scripts/./install-oh-my-zsh.sh
ln -sf ${DOTFILESDIR}/.oh-my-zsh/custom/aliases.zsh ~/.oh-my-zsh/custom/aliases.zsh
${DOTFILESDIR}/scripts/./install-oh-my-zsh-plugins.sh
ln -sf ${DOTFILESDIR}/.p10k.zsh ~/.p10k.zsh
ln -sf ${DOTFILESDIR}/.fzf.zsh ~/.fzf.zsh
mv ~/.zshrc ~/.zshrc_before_home_switch
ln -sf ${DOTFILESDIR}/.zshrc ~/.zshrc
ln -sf ${DOTFILESDIR}/.profile ~/.profile
