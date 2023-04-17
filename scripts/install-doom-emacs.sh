#!/bin/sh

REPOSRC="https://github.com/doomemacs/doomemacs"
LOCALREPO="${HOME}/.emacs.d"

# We do it this way so that we can abstract if from just git later on
LOCALREPO_VC_DIR=$LOCALREPO/.git

if [ ! -d $LOCALREPO_VC_DIR ]
then
    git clone --depth 1 $REPOSRC $LOCALREPO
    ${HOME}/.emacs.d/bin/doom install
else
    cd $LOCALREPO
    git pull $REPOSRC
fi

# End
