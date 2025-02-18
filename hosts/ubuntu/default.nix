{ pkgs, ... }:

{
  imports = [ ../../modules/shared ../../modules/ubuntu ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "my-ubuntu";
  networking.networkmanager.enable = true;

  services.xserver = {
    enable = true;
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
  };

  time.timeZone = "America/Sao_Paulo";

  system.stateVersion = "23.05";
}
