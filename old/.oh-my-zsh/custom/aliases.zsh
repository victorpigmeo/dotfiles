#!/usr/bin/env zsh

alias c='clear'
alias pio='/home/victor/.platformio/penv/bin/pio'

function j(){
    jump "$1"
}

function np(){
    jump "$1" && nvim .
}
