{ config, pkgs, inputs, lib, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ./main-user.nix

      ../../modules/greeter/greetd.nix

      ../../modules/shell/bash.nix
      ../../modules/shell/fish.nix

      ../../modules/programs/xdg.nix
      ../../modules/programs/steam.nix
      inputs.home-manager.nixosModules.default
    ];

  main-user.enable = true;
  main-user.userName = "tuhoiisa";

  # Fonts
  #fonts.packages = with pkgs; [ nerdfonts ];
  fonts.packages = [
    pkgs.fira-sans
    pkgs.roboto
    pkgs.nerd-fonts._0xproto
    pkgs.nerd-fonts.droid-sans-mono
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.package = 
  pkgs.systemd.overrideAttrs (oldAttrs: {
       version = "256.10";
  });

  # Enable flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  networking.hostName = "nixos"; # Define your hostname.

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Istanbul";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "tr_TR.UTF-8";
    LC_IDENTIFICATION = "tr_TR.UTF-8";
    LC_MEASUREMENT = "tr_TR.UTF-8";
    LC_MONETARY = "tr_TR.UTF-8";
    LC_NAME = "tr_TR.UTF-8";
    LC_NUMERIC = "tr_TR.UTF-8";
    LC_PAPER = "tr_TR.UTF-8";
    LC_TELEPHONE = "tr_TR.UTF-8";
    LC_TIME = "tr_TR.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  #services.xserver.displayManager.sddm.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Configure console keymap
  console.keyMap = "us";

  # Enable CUPS to print documents.
  services.printing.enable = false;

  # Enable sound with pipewire.
  #hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.lysec = {
    isNormalUser = true;
    description = "tuhoiisa";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
    ];
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs; };
    users = {
      "tuhoiisa" = import ./home.nix;
    };
  };

  # Install firefox.
  programs.firefox.enable = true;

  # Install Thunar.
  programs.thunar.enable = true;
  services.gvfs.enable = true; # Mount, trash, and other functionalities
  services.tumbler.enable = true; # Thumbnail support for images

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [

    wget
    git
    pavucontrol
    pulseaudio
    waypaper
    pywal16
    pywalfox-native
    arrpc
    swww
  ];

  nix.gc = {
    automatic = true;
    dates = "daily";
    options = "--delete-older-than 7d";
  };

  boot.kernelPackages = pkgs.linuxPackages_cachyos;
  system.stateVersion = "25.05";
}
