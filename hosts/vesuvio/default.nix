# hosts/vesuvio/default.nix
{
  pkgs,
  inputs,
  outputs,
  isTesting,
  ...
}:
let
  darwinPackages = import ../common/packages/packages-darwin.nix { inherit pkgs isTesting; };
in
{
  imports = [
    ../common/darwin
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
    masApps = {
      "1Password for Safari" = 1569813296;
      "World Clock" = 956377119;
      "iStat Menus" = 6499559693;
      "The Unarchiver" = 425424353;
      "Virtual Display Pro" = 6467809379;
    };
  };

}
