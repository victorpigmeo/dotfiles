{ config, pkgs, ... }:

let
  dotfilesDir = "$HOME/.dotfiles";
  emacsPackage = (pkgs.emacsPackagesFor pkgs.emacsNativeComp).emacsWithPackages
    (epkgs: [ epkgs.vterm ]);
in {
  nixpkgs.config.allowUnfree = true;
  nixpkgs.overlays = [
    (import (builtins.fetchGit {
      url = "https://github.com/nix-community/emacs-overlay.git";
      ref = "master";
    }))

  ];

  home = {
    stateVersion = "22.05";
    username = "victor";
    homeDirectory = "/home/victor";

    packages = with pkgs; [
      emacsPackage
      emacs-all-the-icons-fonts

      google-chrome
      spotify
      slack
      discord
      gnupg

      nixfmt
      ripgrep
      (clojure.override { jdk = jdk11; })
      clojure-lsp
      babashka
      clj-kondo
      jet
      (leiningen.override { jdk = jdk11; })

      dart
      flutter
    ];

    activation = {
      linkFiles = config.lib.dag.entryAfter [ "writeBoundary" ] ''
        ${dotfilesDir}/scripts/./install-fzf.sh
        ${dotfilesDir}/scripts/./install-oh-my-zsh.sh
        ln -sf ${dotfilesDir}/.oh-my-zsh/custom/aliases.zsh ~/.oh-my-zsh/custom/aliases.zsh
        ${dotfilesDir}/scripts/./install-oh-my-zsh-plugins.sh
        ln -sf ${dotfilesDir}/.p10k.zsh ~/.p10k.zsh
        ln -sf ${dotfilesDir}/.fzf.zsh ~/.fzf.zsh
        mv ~/.zshrc ~/.zshrc_before_home_switch
        ln -sf ${dotfilesDir}/.zshrc ~/.zshrc
        ln -sf ${dotfilesDir}/.profile ~/.profile
        ${dotfilesDir}/scripts/./install-doom-emacs.sh
        ~/.emacs.d/bin/doom sync 
      '';
    };
  };

  programs = {
    java = {
      enable = true;
      package = pkgs.jdk11;
    };

    emacs = {
      enable = false;
    };

    git = {
      enable = true;
      package = pkgs.gitAndTools.hub;
      userName = "Victor Pigmeo";
      userEmail = "victor.blq@gmail.com";

      ignores = [ ".lsp/.cache" ".clj-kondo/.cache" ];
    };

  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
