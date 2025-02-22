# hosts/macbook/default.nix
{ pkgs, inputs, outputs, ... }:

{
  imports = [
    ../common/global/darwin.nix
  ];

  # Set Git commit hash for darwin-version.
  system.configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;

  system.stateVersion = 6;

  # It me
  # Set fish as the default shell
  users.knownUsers = [ "schmas" ];
  users.users.schmas = {
    home = "/Users/schmas";
    uid = 501;
    isHidden = false;
    # shell = pkgs.fish;
  };

  home-manager = {
    # This is optional, can be removed if you want to use home-manager's only
    users = {
      # Import your home-manager configuration
      schmas = import ../../home/schmas/macos.nix;
    };
  };
}
