# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  #Allow unfree (google-chrome)
  nixpkgs.config.allowUnfree = true;

  #Install virtualbox extension pack
  virtualisation.virtualbox.host.enableExtensionPack = true;

  boot.loader = {
    grub = {
      enable = true;
      version = 2;
      device = "/dev/sda";
    };
  };

  # Set your time zone.
  time.timeZone = "America/Sao_Paulo";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp0s3.useDHCP = true;

  services = {
    gnome.gnome-keyring.enable = true;

    xserver = {
      enable = true;
      layout = "us";
      xkbVariant = "intl";

      displayManager.defaultSession = "none+bspwm";

      windowManager.bspwm = {
        enable = true;
      };
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

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # gnomeExtensions.appindicator
    bspwm
    sxhkd
    polybarFull
    picom
    vim 
    wget
    google-chrome
    emacs
    terminator
    alacritty
  ];

  programs = {
    zsh = {
      enable = true;
      syntaxHighlighting.enable = true;
      enableCompletion = true;
      ohMyZsh = {
        enable = true;
        
      };
    };
  };

  #Fonts
  #fonts = {
   # fonts = with pkgs; [
    #  emacs-all-the-icons-fonts
     # hack-font
     # roboto
     # roboto-mono
     # ibm-plex
    #];

    #fontconfig = {
     # defaultFonts = {
      #  sansSerif = ["roboto" 
       #              "ibm-plex"];
       # monospace = ["roboto-mono" 
       #              "ibm-plex"];
     # };
    #};
 # };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.11"; # Did you read the comment?

}

