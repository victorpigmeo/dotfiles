#!/bin/sh

if [ ! -d ${HOME}/dev/clojure-lsp ]
then
    git clone https://github.com/clojure-lsp/clojure-lsp.git ${HOME}/dev/clojure-lsp
else
    cd ${HOME}/dev/clojure-lsp && git fetch && git pull
fi

if [ ! -d ${HOME}/.config/clojure-lsp ]
then
    mkdir ${HOME}/.config/clojure-lsp
fi

ln -sf ${HOME}/.dotfiles/.config/clojure-lsp/config.edn ${HOME}/.config/clojure-lsp/config.edn
