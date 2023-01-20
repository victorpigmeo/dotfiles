#!/bin/sh

PWRLVL10KREPOSRC="https://github.com/romkatv/powerlevel10k.git"
PWRLVL10KLOCALREPO="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"

PWRLVL10KLOCALREPO_VC_DIR=$PWRLVL10KLOCALREPO/.git

if [ ! -d $PWRLVL10KLOCALREPO_VC_DIR ]
then
	git clone --depth=1 $PWRLVL10KREPOSRC $PWRLVL10KLOCALREPO
fi

ZSHSYNTAXHGHLGHTREPOSRC="https://github.com/zsh-users/zsh-syntax-highlighting.git"
ZSHSYNTAXHGHLGHTLOCALREPO="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"

ZSHSYNTAXHGHLGHTLOCALREPO_VC_DIR=$ZSHSYNTAXHGHLGHTLOCALREPO/.git

if [ ! -d $ZSHSYNTAXHGHLGHTLOCALREPO_VC_DIR ]
then
	git clone --depth=1 $ZSHSYNTAXHGHLGHTREPOSRC $ZSHSYNTAXHGHLGHTLOCALREPO
fi

# End
