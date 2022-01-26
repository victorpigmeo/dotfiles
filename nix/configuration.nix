# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/master.tar.gz";
in
{

  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      (import "${home-manager}/nixos")
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.useOSProber = true;

  # Allow proprietary pkgs
  nixpkgs.config.allowUnfree = true;

  # Enable zsh systemwide
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  home-manager.users.victor = {
    home.packages = with pkgs; [
      vim
      terminator
      spotify
      git
      google-chrome
      vscode
      zsh
    ];

    programs = {
      git = {
        enable = true;
        userName = "Victor Carvalho";
        userEmail = "victor.blq@gmail.com";
      };

      zsh = {
        enable = true;
        autocd = true;
        initExtra = ''
          [[ ! -f "$HOME/.config/zsh/.p10k.zsh" ]] || source "$HOME/.config/zsh/.p10k.zsh"
        '';
        dotDir = ".config/zsh";
        enableSyntaxHighlighting = true;
        shellAliases = {
          c = "clear";
        };
        history = {
          size = 10000;
          path = "$HOME/.local/share/zsh/history";
        };
        oh-my-zsh = {
          enable = true;
          plugins = ["git" "jump"];
        };

        plugins = [
          {
            name = "powerlevel10k";
            src = pkgs.zsh-powerlevel10k;
            file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
          }
        ];
      };
    };
  };

  # Set your time zone.
  time.timeZone = "America/Sao_Paulo";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking = {
    useDHCP = false;
    hostName = "vnixos";
    nameservers = ["208.67.222.222" "208.67.220.220"];
    interfaces = {
      enp3s0 = {
        useDHCP = false;
        ipv4 = {
          addresses = [
            {
              address = "192.168.100.4";
              prefixLength = 24; 
            }
          ];

          routes = [
            {
              address = "0.0.0.0";
              prefixLength = 0;
	            via = "192.168.100.1";
            }
	          {
              address = "192.168.100.0";
              prefixLength = 24;
              via = "192.168.100.1";
            }
          ];
        };
      };
    };
  };

  # Enable the X11 windowing system.
  services = {
    xserver = {
      enable = true;

      displayManager = {
        gdm.enable = true;
      };

      # Enable the GNOME Desktop Environment.
      desktopManager = {
        gnome.enable = true;
      };

      # Configure keymap in X11
      layout = "us";
      xkbVariant = "intl";
    };
  };

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.victor = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.11"; # Did you read the comment?

}