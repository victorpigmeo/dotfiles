#!/usr/bin/env zsh

alias c='clear'
alias update-clojure-lsp='bash <(curl -s https://raw.githubusercontent.com/clojure-lsp/clojure-lsp/master/install) --dir ~/dev/clojure-lsp/ --version nightly --static'
alias creds='nu aws shared-role-credentials refresh --interactive --deps'
alias vpn='sudo -E gpclient connect zta.nubank.world'
alias pio='/home/victor/.platformio/penv/bin/pio'

function j(){
    jump "$1"
}
