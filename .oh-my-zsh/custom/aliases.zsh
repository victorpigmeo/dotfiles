#!/usr/bin/env zsh

alias c='clear'
alias vpn='sudo openfortivpn -c "$NU_HOME/.nu-vpn"'
alias credentials='nu aws credentials refresh'
alias xsetrs='xset r rate 220 50'


function j(){
    jump "$1"
}
