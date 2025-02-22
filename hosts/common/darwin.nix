# This file (and the global directory) holds config that i use on all hosts
{ inputs, outputs, ... }:
{
  imports =
    [
      inputs.home-manager.darwinModules.home-manager
    ]
    ++ (builtins.attrValues outputs.darwinModules)
    ++ [
      ./global
    ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";
    extraSpecialArgs = { inherit inputs outputs; };
    sharedModules = [ inputs.mac-app-util.homeManagerModules.default ];
  };
}
