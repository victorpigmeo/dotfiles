#!/usr/bin/env zsh

alias c='clear'
alias vpn='xset r rate 220 50 && sudo openfortivpn -c "$NU_HOME/.nu-vpn"'
alias credentials='nu aws credentials refresh --npm-login'
alias update-clojure-lsp='bash <(curl -s https://raw.githubusercontent.com/clojure-lsp/clojure-lsp/master/install) --dir ~/dev/clojure-lsp/ --version nightly --static'


function j(){
    jump "$1"
}
