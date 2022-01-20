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

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Set your time zone.
  time.timeZone = "America/Sao_Paulo";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp0s3.useDHCP = true;

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  # };

  # Enable the X11 windowing system.
  #services.xserver.enable = true;
  #services.xserver.displayManager.gdm.enable = true;
  #services.xserver.desktopManager.gnome.enable = true;
  services = {
    gnome.gnome-keyring.enable = true;

    xserver = {
      enable = true;
      layout = "us";
      xkbVariant = "intl";
      videoDrivers = ["nvidia"];

      displayManager.defaultSession = "none+bspwm";

     # displayManager.sessionCommands = ''
      #  ${pkgs.xlibs.xsetroot}/bin/xsetroot -cursor_name left_ptr &
       # ${pkgs.xorg.xrdb}/bin/xrdb -merge <<EOF
        #  Xcursor.theme: Adwaita
         # Xcursor.size: 24
       # EOF
     # '';

      #displayManager.lightdm = {
      #  enable = true;
#	      greeters.mini = {
#	        enable = true;
#	        user = "victor";
#	      };
 #     };
      
      windowManager.bspwm = {
        enable = true;
      };
    };

  };
  
  #services.udev.packages = with pkgs; [gnome3.gnome-settings-daemon];
  # Configure keymap in X11
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e";

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
  ];

  #environment.gnome.excludePackages = [ pkgs.gnome.cheese pkgs.gnome-photos pkgs.gnome.gnome-music pkgs.gnome.gnome-terminal pkgs.gnome.gedit pkgs.epiphany pkgs.evince pkgs.gnome.gnome-characters pkgs.gnome.totem pkgs.gnome.tali pkgs.gnome.iagno pkgs.gnome.hitori pkgs.gnome.atomix pkgs.gnome-tour pkgs.gnome.geary ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  #services.openssh.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.11"; # Did you read the comment?

}

