#!/bin/sh

BSPWM_CONFIG_DIR="${HOME}/.config/bspwm"
BSPWM_CONFIG_FILE="${BSPWM_CONFIG_DIR}/bspwmrc"
SXHKD_CONFIG_DIR="${HOME}/.config/sxhkd"
SXHKD_CONFIG_FILE="${SXHKD_CONFIG_DIR}/sxhkdrc"

sudo apt install bspwm sxhkd
sudo apt install tmux
sudo apt install feh

echo "Checking for existing bspwmrc file"
if [ -d $BSPWM_CONFIG_DIR ]; then
    echo "BSPWM dir already exists"
else
    mkdir $BSPWM_CONFIG_DIR
fi

echo "Checking for existing sxhkdrc file"
if [ -d $SXHKD_CONFIG_DIR ]; then
    echo "SXHKD dir already exists"
else
    mkdir $SXHKD_CONFIG_DIR
fi

ln -sf ${HOME}/.dotfiles/.config/bspwm/bspwmrc ${HOME}/.config/bspwm/bspwmrc
ln -sf ${HOME}/.dotfiles/.config/sxhkd/sxhkdrc ${HOME}/.config/sxhkd/sxhkdrc

#terminal config
ln -sf ${HOME}/.dotfiles/.Xresources ${HOME}/.Xresources

#rofi config
ln -sf ${HOME}/.dotfiles/.config/rofi/launchers ${HOME}/.config/rofi/launchers
