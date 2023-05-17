#!/bin/sh

REPOSRC="https://github.com/doomemacs/doomemacs"
LOCALREPO="${HOME}/.config/emacs"
DOTFILESDIR="${HOME}/.dotfiles"

# We do it this way so that we can abstract if from just git later on
LOCALREPO_VC_DIR=$LOCALREPO/.git

sudo apt install ripgrep

if [ ! -d ${HOME}/.config/doom ]
then
    mkdir ${HOME}/.config/doom
fi

ln -sf ${DOTFILESDIR}/.doom.d/*.el ${HOME}/.config/doom/

if [ ! -d $LOCALREPO_VC_DIR ]
then
    git clone --depth 1 $REPOSRC $LOCALREPO
    ${HOME}/.config/emacs/bin/doom install
else
    cd $LOCALREPO
    git pull $REPOSRC
    ${HOME}/.config/emacs/bin/doom sync
fi

# End
