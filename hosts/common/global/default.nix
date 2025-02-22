{ inputs, outputs, pkgs, lib, ... }:
{
    imports =
    [
      ./nix.nix
      ./shells.nix
    ];

  nixpkgs = {
    overlays = builtins.attrValues outputs.overlays;
    config = {
      allowUnfree = true;
      allowBroken = true;
      allowInsecure = false;
      allowUnsupportedSystem = true;
    };
  };
}
