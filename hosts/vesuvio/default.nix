# hosts/vesuvio/default.nix
{ pkgs, inputs, outputs, ... }:

{
  imports = [
    ../common/darwin.nix
  ];

  # Set Git commit hash for darwin-version.
  system.configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;

  system.stateVersion = 6;

  networking = {
    hostName = "vesuvio";
  };

  # It me
  # Set fish as the default shell
  users.knownUsers = [ "${outputs.user}" ];
  users.users.schmas = {
    home = "/Users/${outputs.user}";
    uid = 501;
    isHidden = false;
    shell = pkgs.fish;
  };

  home-manager = {
    users = {
      schmas = import ../../home/${outputs.user}/macos.nix;
    };
  };
}
