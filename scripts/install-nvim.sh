#!/bin/sh

curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz

sudo rm -rf /opt/nvim 

sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz

ln -sf /home/victor/.dotfiles/.config/nvim /home/victor/.config/nvim 
