{ user, pkgs, ... }:
{
  imports = [
    ./packages.nix
  ];

  users.users.${user} = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    shell = pkgs.fish;
  };
}
