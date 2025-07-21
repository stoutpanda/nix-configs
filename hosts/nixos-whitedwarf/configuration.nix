# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  config,
  pkgs,
  inputs,
  chaotic,
  lib,
  ...
}:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    inputs.nixos-hardware.nixosModules.asus-zephyrus-ga402x-nvidia
    ../../modules/hyprland.nix
    ./gnome-keyring.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Filesystem support
  boot.supportedFilesystems = [ "f2fs" ];

  # Default kernal
  #boot.kernelPackages = pkgs.linuxPackages_latest;

  #chaotic zen kernel
  boot.kernelPackages = pkgs.linuxPackages_cachyos;
  services.scx = {
    enable = true;
    package = pkgs.scx.full;
  };
  programs.gamemode.enable = true;
  boot.initrd.luks.devices."luks-0a3129ec-d9a5-4676-9db3-8d35bb241213".device =
    "/dev/disk/by-uuid/0a3129ec-d9a5-4676-9db3-8d35bb241213";
  networking.hostName = "nixos-whitedwarf"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager = {
    enable = true;
  };
  # for asus laptop specifically

  # ASUS laptop control daemon
  services.asusd = {
    enable = true;
    enableUserService = true;
  };

  # Enable ZSA keyboard support
  hardware.keyboard.zsa.enable = true;

  # Enable CUPS to print documents.
  services.printing = {
    enable = true;
    drivers = with pkgs; [
      gutenprint
      epson-escpr # ESC/P-R Driver (generic driver)
      epson-escpr2 # ESC/P-R 2 Driver (generic driver)
      # epson-inkjet-printer-workforce # Proprietary CUPS drivers for Epson inkjet printers
      epsonscan2
      brlaser # CUPS driver for Brother laser printers
    ];
  };

  # Enable scanner support for multifunction printers
  hardware.sane = {
    enable = true;
    extraBackends = [
      pkgs.epsonscan2
      pkgs.utsushi
    ];
  };

  # Install printer management tools
  environment.systemPackages = with pkgs; [
    system-config-printer
    simple-scan
  ];

  # Specialization for power-saving mode with disabled NVIDIA GPU
  specialisation = {
    power-saving.configuration = {
      # Completely disable NVIDIA GPU
      hardware.nvidiaOptimus.disable = true;
      
      # Force disable any NVIDIA services
      hardware.nvidia = {
        prime.offload.enable = lib.mkForce false;
        prime.offload.enableOffloadCmd = lib.mkForce false;
        prime.sync.enable = lib.mkForce false;
      };
      
      # Disable NVIDIA settings GUI
      hardware.nvidia.nvidiaSettings = false;
    };
  };

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

  # Mount microSD card for Steam
  fileSystems."/mnt/steam" = {
    device = "/dev/disk/by-label/steam";
    fsType = "ext4";
    options = [
      "auto"
      "exec"
      "rw"
      "nofail"
    ];
  };

  # enable printer discovery
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

}
