#!/usr/bin/env bash

# Setup zsh
echo "Setting up zsh..."
mv ~/.zshrc .zshrc_old
ln ~/dotfiles/.zshrc ~/.zshrc
echo "Finish setup zsh."

echo "Setting up oh-my-zsh..."
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
rm ~/.oh-my-zsh/custom/*.zsh
ln ~/dotfiles/oh-my-zsh/custom/aliases.zsh ~/.oh-my-zsh/custom/aliases.zsh
ln ~/dotfiles/oh-my-zsh/custom/config.zsh ~/.oh-my-zsh/custom/config.zsh
echo "Finish setting up oh-my-zsh"

echo "Setting up emacs..."
brew install git ripgrep coreutils fd
xcode-select --install

brew tap railwaycat/emacsmacport
brew install emacs-mac --with-modules
ln -s /usr/local/opt/emacs-mac/Emacs.app /Applications/Emacs.app
echo "Finish setting up emacs"

echo "Setting up Doom..."
git clone --depth 1 https://github.com/hlissner/doom-emacs ~/.emacs.d
~/.emacs.d/bin/doom install

echo "Finish setting up Doom"
