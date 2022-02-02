#!/usr/bin/env bash

echo "Linking nix configurations"
sudo ln -f ~/.dotfiles/nix/configuration.nix /etc/nixos/
echo "Succesfully linked nix configurations"

echo "Linking doom-emacs configurations"
[ -d "${HOME}/.doom.d" ] && echo "~/.doom.d directory already exists" || mkdir ${HOME}/.doom.d

ln -sf ${HOME}/.dotfiles/.doom.d/init.el ${HOME}/.doom.d/
ln -sf ${HOME}/.dotfiles/.doom.d/config.el ${HOME}/.doom.d/
ln -sf ${HOME}/.dotfiles/.doom.d/packages.el ${HOME}/.doom.d/
echo "Succesfully linked doom-emacs configurations"

echo "Linking bspwm+sxhkd configurations"
[ -d "${HOME}/.config/bspwm" ] && echo "~/.config/bspwm directory already exists" || mkdir -r ${HOME}/.config/bspwm
[ -d "${HOME}/.config/sxhkd" ] && echo "~/.config/sxhkd directory already exists" || mkdir -r ${HOME}/.config/sxhkd

ln -f ${HOME}/.dotfiles/.config/bspwm/bspwmrc ${HOME}/.config/bspwm/bspwmrc
ln -sf ${HOME}/.dotfiles/.config/sxhkd/sxhkdrc ${HOME}/.config/sxhkd/sxhkdrc
echo "Succesfully linked bspwm+sxhkd"

echo "Linking desktop files"
[ -d "${HOME}/.local/share/applications" ] && echo "~/.local/share/applications directory already exists" || mkdir -r ${HOME}/.config/bspwm

ln -sf ${HOME}/.dotfiles/.local/share/applications/youtube_music.desktop ${HOME}/.local/share/applications/youtube_music.desktop
echo "Succesfully linked desktop files"
# StartupWMClass=crx_cinhimbnkkaeohfgghhklpknlkffjgod
