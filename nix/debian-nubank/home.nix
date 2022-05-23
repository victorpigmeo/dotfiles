{ config, pkgs, ... }:

let
    dotfilesDir = "$HOME/.dotfiles";
    emacsPackage = (pkgs.emacsPackagesFor pkgs.emacsNativeComp).emacsWithPackages
      (epkgs: [ epkgs.vterm ]);
in
{
  nixpkgs.config.allowUnfree = true;
  nixpkgs.overlays = [
    (import (builtins.fetchGit {
      url = "https://github.com/nix-community/emacs-overlay.git";
      ref = "master";
    }))

    (import (builtins.fetchGit {
      url = "https://github.com/nubank/nixpkgs";
    }))
  ];

  home = {
    stateVersion = "22.05";
    username = "victor";
    homeDirectory = "/home/victor";

    packages = with pkgs; [

      spotify
      slack
      terminator
      discord
      zoom-us
      gnupg

      (clojure.override { jdk = jdk11; })
      clojure-lsp
      babashka
      clj-kondo
      jet
      (leiningen.override { jdk = jdk11; })

      go
      nubank.dart
      nubank.flutter
    ];

    activation = {
      linkFiles = config.lib.dag.entryAfter [ "writeBoundary" ] ''
          ln -sf ${dotfilesDir}/.doom.d/*.el ~/.doom.d/
          ln -sf ${dotfilesDir}/nix/.zshrc ~/.zshrc
          ln -sf ${dotfilesDir}/nix/.p10k.zsh ~/.p10k.zsh
          ln -sf ${dotfilesDir}/nix/.fzf.zsh ~/.fzf.zsh
          mkdir -p ~/.oh-my-zsh/custom/
          ln -sf ${dotfilesDir}/nix/.oh-my-zsh/custom/aliases.zsh ~/.oh-my-zsh/custom/aliases.zsh
          '';
    };
  };

  programs = {
    java = {
      enable = true;
      package = pkgs.jdk11;
    };

    emacs = {
      enable = true;
      package = emacsPackage;
    };

    git = {
      enable = true;
      package = pkgs.gitAndTools.hub;
      userName = "Victor Pigmeo";
      userEmail = "victor.blq@gmail.com";
      signing = {
        key = "EEB2A1692650A7A";
        signByDefault = true;
      };

      includes = [{ path = "~/.dotfiles/.gitconfig"; }];

      ignores = [ ".lsp/.cache" ".clj-kondo/.cache" ];
    };

  };
  
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
