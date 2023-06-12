#!/usr/bin/env zsh

alias c='clear'
alias vpn='xset r rate 220 50 && sudo openfortivpn -c "$NU_HOME/.nu-vpn"'
alias credentials='nu aws credentials refresh --npm-login'


function j(){
    jump "$1"
}
