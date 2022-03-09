#!/usr/bin/env bash

echo "Linking doom-emacs configurations"
[ -d "${HOME}/.doom.d" ] && echo "~/.doom.d directory already exists" || mkdir ${HOME}/.doom.d

ln -sf ${HOME}/.dotfiles/.doom.d/init.el ${HOME}/.doom.d/
ln -sf ${HOME}/.dotfiles/.doom.d/config.el ${HOME}/.doom.d/
ln -sf ${HOME}/.dotfiles/.doom.d/packages.el ${HOME}/.doom.d/
ln -sf ${HOME}/.dotfiles/.doom.d/+bindings.el ${HOME}/.doom.d/
echo "Succesfully linked doom-emacs configurations"

echo "Linking oh-my-zsh configurations"
[ -d "${HOME}/.oh-my-zsh/custom" ] && echo "~/.oh-my-zsh/custom directory already exists" || mkdir ${HOME}/.oh-my-zsh/custom

ln -sf ${HOME}/.dotfiles/manjaro/.zshrc ${HOME}/
ln -sf ${HOME}/.dotfiles/manjaro/.p10k.zsh ${HOME}/
ln -sf ${HOME}/.dotfiles/manjaro/.fzf.zsh ${HOME}/
ln -sf ${HOME}/.dotfiles/manjaro/.oh-my-zsh/custom/aliases.zsh ${HOME}/.oh-my-zsh/custom/
echo "Succesfully linked oh-my-zsh configurations"
