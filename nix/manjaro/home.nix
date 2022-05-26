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

    emacs = { enable = false; };

    git = {
      enable = true;
      package = pkgs.gitAndTools.hub;
      userName = "Victor Pigmeo";
      userEmail = "victor.blq@gmail.com";

      ignores = [ ".lsp/.cache" ".clj-kondo/.cache" ];
    };

    tmux = {
      enable = true;
      clock24 = true;

      extraConfig = ''
        bind-key -n M-x kill-pane
        bind-key -n M-c new-window
        bind -n M-Right next-window
        bind -n M-Left previous-window
        bind-key -n M-h split-window -h
        bind-key -n M-v split-window -v
        bind-key -n C-Left select-pane -L
        bind-key -n C-Right select-pane -R
        bind-key -n C-Up select-pane -U
        bind-key -n C-Down select-pane -D
      '';
    };

  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
