#!/bin/sh

# echo "Linking nix configurations"
# sudo ln -f ~/.dotfiles/nix/configuration.nix /etc/nixos/
# echo "Succesfully linked nix configurations"

echo "Linking doom-emacs configurations"
[ -d "${HOME}/.doom.d" ] && echo "~/.doom.d directory already exists" || mkdir ${HOME}/.doom.d 

ln -sf ${HOME}/.dotfiles/.doom.d/init.el ${HOME}/.doom.d/
ln -sf ${HOME}/.dotfiles/.doom.d/config.el ${HOME}/.doom.d/
ln -sf ${HOME}/.dotfiles/.doom.d/packages.el ${HOME}/.doom.d/
echo "Succesfully linked doom-emacs configurations"