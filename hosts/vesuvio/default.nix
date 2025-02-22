# hosts/vesuvio/default.nix
{
  pkgs,
  inputs,
  outputs,
  ...
}:
let
  darwinPackages = import ../common/packages/packages-darwin.nix { inherit pkgs; };
in
{
  imports = [
    ../common/darwin.nix
  ];

  _module.args = {
    user = "schmas";
  };

  # Set Git commit hash for darwin-version.
  system.configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;

  system.stateVersion = 6;

  networking = {
    hostName = "vesuvio";
  };

  # It me
  # Set fish as the default shell
  users.knownUsers = [ "schmas" ];
  users.users.schmas = {
    home = "/Users/schmas";
    uid = 501;
    isHidden = false;
    shell = pkgs.fish;
  };

  home-manager = {
    users = {
      schmas = { inputs, outputs, pkgs, ... }: {
        imports = [ ../../home/schmas/vesuvio.nix ];
        home.packages = darwinPackages.packages;
      };
    };
  };

  homebrew = {
    enable = true;
    brews = darwinPackages.brews;
    casks = darwinPackages.casks;
    onActivation = {
      cleanup = "zap";
      autoUpdate = true;
      upgrade = true;
    };
  };

}
