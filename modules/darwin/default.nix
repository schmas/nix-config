{ user, pkgs, nix-homebrew, homebrew-bundle, homebrew-core, homebrew-cask, ... }:

{
  imports = [
    ./packages.nix
    ./settings.nix
    nix-homebrew.darwinModules.nix-homebrew
  ];

  # It me
  # Set fish as the default shell
  users.knownUsers = [ "${user}" ];
  users.users.${user} = {
    home = "/Users/${user}";
    uid = 501;
    isHidden = false;
    shell = pkgs.fish;
  };

  nix-homebrew = {
    enable = true;
    enableRosetta = true;
    user = "${user}";
    taps = {
      "homebrew/homebrew-core" = homebrew-core;
      "homebrew/homebrew-cask" = homebrew-cask;
      "homebrew/homebrew-bundle" = homebrew-bundle;
    };
    mutableTaps = false;
    autoMigrate = true;
  };
}
