#!/usr/bin/sh

FZFREPOSRC="https://github.com/junegunn/fzf.git"
FZFLOCALREPO="${HOME}/.fzf"

FZFLOCALREPO_VC_DIR=$FZFLOCALREPO/.git

if [ ! -d $FZFLOCALREPO_VC_DIR ]
then
	git clone --depth=1 $FZFREPOSRC $FZFLOCALREPO
	${HOME}/.fzf/install
fi

# End
