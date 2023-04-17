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

    # (import (builtins.fetchGit { url = "https://github.com/nubank/nixpkgs"; }))
  ];

  home = {
    stateVersion = "22.05";
    username = "victor";
    homeDirectory = "/home/victor";

    packages = with pkgs; [
      emacsPackage

      slack
      discord
      gnupg
      spotify

      nixfmt
      ripgrep
      (clojure.override { jdk = jdk11; })
      clojure-lsp
      # babashka
      clj-kondo
      gotop
      jet
      postman
      (leiningen.override { jdk = jdk11; })

      go
      tektoncd-cli
      #dart
      #flutter
    ];

    activation = {
      linkFiles = config.lib.dag.entryAfter [ "writeBoundary" ] ''
        ln -sf ${dotfilesDir}/.doom.d/*.el ~/.doom.d/
      '';
    };
  };

  programs = {
    java = {
      enable = true;
      package = pkgs.jdk11;
    };

    emacs = { enable = false; };

    git = {
      enable = true;
      package = pkgs.gitAndTools.hub;
      userName = "Victor Pigmeo";
      userEmail = "victor.blq@gmail.com";
      signing = {
        key = "E892323E59CCCB99";
        signByDefault = true;
      };

      includes = [{ path = "~/.dotfiles/.gitconfig"; }];

      ignores = [ ".lsp/.cache" ".clj-kondo/.cache" ];
    };

  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
