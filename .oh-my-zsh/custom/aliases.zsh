#!/usr/bin/env zsh

alias c='clear'
alias vpn='sudo openfortivpn -c "$NU_HOME/.nu-vpn"'
alias credentials='nu aws credentials refresh --maven-login'

function j(){
    jump "$1"
}
