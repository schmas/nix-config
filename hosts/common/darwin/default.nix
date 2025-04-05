# This file (and the global directory) holds config that i use on all hosts
{
  inputs,
  outputs,
  nix-homebrew,
  user,
  ...
}:
{
  imports =
    [
      inputs.home-manager.darwinModules.home-manager
      inputs.nix-homebrew.darwinModules.nix-homebrew
    ]
    ++ (builtins.attrValues outputs.darwinModules)
    ++ [
      ../global
      ./settings.nix
    ];

  nix = {
    # Disable nix-darwin's Nix management when using Determinate Systems Nix
    enable = false;

    settings = {
      trusted-users = [ "@admin" "${user}" ];
    };
  };

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
    mutableTaps = true;
    # autoMigrate = true;
  };
}
