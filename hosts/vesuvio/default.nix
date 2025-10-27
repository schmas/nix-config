# hosts/vesuvio/default.nix
{
  pkgs,
  inputs,
  outputs,
  ...
}:
let
  darwinPackages = import ../common/packages/packages-darwin.nix { inherit pkgs; };
  user = "schmas";
in
{
  imports = [
    ../common/darwin
  ];

  _module.args = {
    inherit user;
  };

  # Set Git commit hash for darwin-version.
  system.configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;

  system.stateVersion = 6;

  networking = {
    hostName = "vesuvio";
    localHostName = "vesuvio";
  };

  # It me
  # Set fish as the default shell
  users.knownUsers = [ user ];
  users.users.${user} = {
    home = "/Users/${user}";
    uid = 501;
    isHidden = false;
    shell = pkgs.fish;
  };

  # Set primary user for nix-darwin
  system.primaryUser = user;

  home-manager = {
    users = {
      ${user} =
        {
          inputs,
          outputs,
          pkgs,
          ...
        }:
        {
          imports = [ ../../home/${user}/vesuvio.nix ];
          home.packages = darwinPackages.packages;
        };
    };
  };

  homebrew = {
    enable = true;
    brews = darwinPackages.brews;
    casks = darwinPackages.casks;
    onActivation = {
      cleanup = "none";
      autoUpdate = true;
      upgrade = true;
    };
    # masApps = {
    #   "1Password for Safari" = 1569813296;
    #   "World Clock" = 956377119;
    #   "iStat Menus" = 6499559693;
    #   "The Unarchiver" = 425424353;
    #   "Virtual Display Pro" = 6467809379;
    # };
  };

}
