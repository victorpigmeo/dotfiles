#!/usr/bin/env zsh

alias c='clear'
alias vpn='xset r rate 220 50 && sudo openfortivpn -c "$NU_HOME/.nu-vpn"'
alias update-clojure-lsp='bash <(curl -s https://raw.githubusercontent.com/clojure-lsp/clojure-lsp/master/install) --dir ~/dev/clojure-lsp/ --version nightly --static'
alias credentials-stg='nu aws shared-role-credentials refresh --account-alias=br'
alias credentials-prod='nu aws credentials refresh'
alias credentials-full='credentials-stg && credentials-prod'
alias refresh-token='nu-br-staging auth get-refresh-token --force && nu-br-staging auth get-access-token'
alias login-stg='nu-br-staging customer get-keys-and-certificates'
alias nix-flake-install='NIXPKGS_ALLOW_UNFREE=1 home-manager switch --impure --flake /home/victor/.dotfiles/nix/debian-nubank/'

function j(){
    jump "$1"
}
