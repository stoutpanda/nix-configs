# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, chaotic,  ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      inputs.nixos-hardware.nixosModules.asus-zephyrus-ga402x-nvidia
      ../../modules/kde.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Default kernal
  #boot.kernelPackages = pkgs.linuxPackages_latest;
 
  #chaotic zen kernel
  boot.kernelPackages = pkgs.linuxPackages_cachyos;
  services.scx.enable = true; # Uses scx_rustland by default
  programs.gamemode.enable = true; 
  boot.initrd.luks.devices."luks-0a3129ec-d9a5-4676-9db3-8d35bb241213".device = "/dev/disk/by-uuid/0a3129ec-d9a5-4676-9db3-8d35bb241213";
  networking.hostName = "nixos-whitedwarf"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;
  # for asus laptop specifically

  # ASUS laptop control daemon
  services.asusd = {
    enable = true;
    enableUserService = true;
  };


  # Enable ZSA keyboard support
  hardware.keyboard.zsa.enable = true;


  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
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

  # Enable Steam
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  };

  # Enable 32-bit support for Steam
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };
}	
