#!/usr/bin/env zsh

alias c='clear'
alias vpn='xset r rate 220 50 && sudo openfortivpn -c "$NU_HOME/.nu-vpn"'
alias credentials='nu aws credentials refresh'
alias update-clojure-lsp='bash <(curl -s https://raw.githubusercontent.com/clojure-lsp/clojure-lsp/master/install) --dir ~/dev/clojure-lsp/ --version nightly --static'
alias refresh-stg='nu update && credentials &&  nu auth get-refresh-token --country br --env staging --force && nu auth get-access-token --country br --env staging && sed -i "s/v1alpha1/v1beta1/g" ~/.kube/config'
alias refresh-prod='nu update && credentials &&  nu auth get-refresh-token --country br --env prod --force && nu auth get-access-token --country br --env prod && sed -i "s/v1alpha1/v1beta1/g" ~/.kube/config'
alias login-stg='refresh-stg && nu customer get-keys-and-certificates --env staging'


function j(){
    jump "$1"
}
