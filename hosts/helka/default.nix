# hosts/helka/default.nix
{
  pkgs,
  inputs,
  outputs,
  ...
}:
let
  sharedPackages = import ../common/packages/packages.nix { inherit pkgs; };
  user = "schmas";
in
{
  imports = [
    ../common/linux
  ];

  _module.args = {
    inherit user;
  };

  system.stateVersion = "25.05";

  networking = {
    hostName = "helka";
  };

  # Boot and filesystem configuration (hardware-specific, update as needed)
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "ext4";
  };

  # It me
  # Set fish as the default shell
  users.users.${user} = {
    home = "/home/${user}";
    isNormalUser = true;
    shell = pkgs.fish;
    extraGroups = [ "wheel" ];
  };

  home-manager = {
    users = {
      ${user} =
        {
          inputs,
          outputs,
          pkgs,
          ...
        }:
        {
          imports = [ ../../home/${user}/helka.nix ];
          home.packages = sharedPackages.all-packages;
        };
    };
  };

  environment.systemPackages = [ ];
}
