#!/usr/bin/env zsh

alias c='clear'
# alias vpn='sudo openfortivpn -c "$NU_HOME/.nu-vpn"'
alias update-clojure-lsp='bash <(curl -s https://raw.githubusercontent.com/clojure-lsp/clojure-lsp/master/install) --dir ~/dev/clojure-lsp/ --version nightly --static'
# alias credentials-stg='nu aws shared-role-credentials refresh --account-alias=br --drop-policies databricks-br-general,databricks-co-general,databricks-general'
# alias credentials-prod='nu aws credentials refresh --npm-login'
alias creds='nu aws shared-role-credentials refresh --interactive --deps'
alias vpn='sudo -E gpclient connect zta.nubank.world'
# alias credentials-full='credentials-stg && credentials-prod'
# alias nix-flake-install='NIXPKGS_ALLOW_UNFREE=1 home-manager switch --impure --flake /home/victor/.dotfiles/nix/debian-nubank/'

alias co-token='nu-co auth get-refresh-token --env staging --force && nu-co auth get-access-token'
alias co-login='nu-co customer get-keys-and-certificates --env staging'

function j(){
    jump "$1"
}
