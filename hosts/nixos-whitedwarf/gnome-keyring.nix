{ config, lib, pkgs, ... }:

{
  # Enable GNOME keyring at system level
  services.gnome.gnome-keyring.enable = true;
  
  # Configure PAM to unlock keyring on login
  security.pam.services = {
    greetd = {
      enableGnomeKeyring = true;
    };
    
    # Also enable for other login methods if needed
    login = {
      enableGnomeKeyring = true;
    };
  };
  
  # Ensure D-Bus is available for keyring communication
  services.dbus.packages = [ pkgs.gnome-keyring ];
  
  # Optional: Add gcr for certificate/key prompts
  environment.systemPackages = with pkgs; [
    gcr
  ];
}