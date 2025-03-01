# This file (and the global directory) holds config that i use on all hosts
{ inputs, outputs, ... }:
{
  imports =
    [ inputs.home-manager.nixosModules.home-manager ]
    ++ (builtins.attrValues outputs.nixosModules)
    ++ [
      ./global
    ];

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.backupFileExtension = "backup";
  home-manager.extraSpecialArgs = { inherit inputs outputs; };
}
