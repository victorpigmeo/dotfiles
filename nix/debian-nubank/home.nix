{ config, pkgs, ... }:

let
  homeDir = "$HOME";
  emacsPackage = (pkgs.emacsPackagesFor pkgs.emacs-unstable).emacsWithPackages
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
    stateVersion = "23.11";
    username = "victor";
    homeDirectory = "/home/victor";

    packages = with pkgs; [
      emacsPackage
      google-chrome
      slack
      discord
      gnupg
      nixfmt
      ripgrep
      clojure
      # clojure-lsp
      babashka-unwrapped
      clj-kondo
      gotop
      jet
      (leiningen.override { jdk = jdk17; })
      htop
      go
      tektoncd-cli
      rxvt-unicode
      peek
      # dmenu
      rofi
      polybar
      kubectl
      # betterlockscreen
      # xsecurelock
      scrot
      dunst
      playerctl
      flameshot
      font-manager
      yad
      xdotool
    ];
  };

  programs = {
    # java = {
    #   enable = true;
    #   package = pkgs.jdk17_headless;
    # };

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

    # Let Home Manager install and manage itself.
    home-manager.enable = true;
  };

}
