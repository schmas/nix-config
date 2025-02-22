# This file (and the global directory) holds config that i use on all hosts
{
  inputs,
  outputs,
  nix-homebrew,
  user,
  ...
}:
{
  imports = [ inputs.home-manager.darwinModules.home-manager inputs.nix-homebrew.darwinModules.nix-homebrew ]
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

  nix-homebrew = {
    enable = true;

    enableRosetta = true;
    user = "${user}";
    taps = {
      "homebrew/homebrew-core" = inputs.homebrew-core;
      "homebrew/homebrew-cask" = inputs.homebrew-cask;
      "homebrew/homebrew-bundle" = inputs.homebrew-bundle;
    };
    mutableTaps = false;
    autoMigrate = true;
  };
}
