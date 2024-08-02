#!/bin/sh

BSPWM_CONFIG_DIR="${HOME}/.config/bspwm"
BSPWM_CONFIG_FILE="${BSPWM_CONFIG_DIR}/bspwmrc"
SXHKD_CONFIG_DIR="${HOME}/.config/sxhkd"
SXHKD_CONFIG_FILE="${SXHKD_CONFIG_DIR}/sxhkdrc"

sudo apt install bspwm sxhkd tmux feh xinput -y

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
    mkdir -p $SXHKD_CONFIG_DIR
fi

ln -sf ${HOME}/.dotfiles/.config/bspwm/bspwmrc ${HOME}/.config/bspwm/bspwmrc
ln -sf ${HOME}/.dotfiles/.config/sxhkd/sxhkdrc ${HOME}/.config/sxhkd/sxhkdrc

#terminal config
ln -sf ${HOME}/.dotfiles/.Xresources ${HOME}/.Xresources

#rofi config
if [ ! -d ${HOME}/.config/rofi ]; then
    mkdir -p ${HOME}/.config/rofi
fi

#get rofi themes
git clone https://github.com/adi1090x/rofi.git \

cd rofi \

#install rofi themes
./setup.sh \

cd .. \

rm -rf rofi;

if [ ! -d ${HOME}/.config/polybar ]; then
    mkdir -p ${HOME}/.config/polybar
fi

#create home/bin directory
if [ ! -d ${HOME}/bin ]; then
    mkdir -p ${HOME}/bin
fi

#polybar setup
ln -sf ${HOME}/.dotfiles/.config/polybar/config.ini ${HOME}/.config/polybar/config.ini
ln -sf ${HOME}/.dotfiles/bin/popup-calendar.sh ${HOME}/bin/popup-calendar.sh
#ln -sf ${HOME}/.dotfiles/.config/polybar/vpn.sh ${HOME}/.config/polybar/vpn.sh
ln -sf ${HOME}/.dotfiles/.config/polybar/headset.sh ${HOME}/.config/polybar/headset.sh

#enable natural scrolling
xinput set-prop 15 322 1

#enable adding ssh keys to agent
ln -sf ${HOME}/.dotfiles/.ssh/config ${HOME}/.ssh/config

#multi monitor setup
sudo apt install iwatch

ln -sf ${HOME}/.dotfiles/bin/monitor-switcher ${HOME}/bin/monitor-switcher
ln -sf ${HOME}/.dotfiles/bin/monitor-switcher-triggered ${HOME}/bin/monitor-switcher-triggered
#file below don't exist
#ln -sf ${HOME}/.dotfiles/bin/external-window-rules.sh ${HOME}/bin/external-window-rules.sh

sudo ln -sf ${HOME}/.dotfiles/udev-rules/10-input-monitor.rules /etc/udev/rules.d/10-input-monitor.rules

touch ${HOME}/.monitor-switcher.log

sudo udevadm control -R
sudo service udev restart
#end multi monitor setup

#sera?
#ln -sf /home/victor/.nix-profile/share/applications /home/victor/.local/share/applications

