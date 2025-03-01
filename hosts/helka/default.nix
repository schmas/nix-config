# hosts/vesuvio/default.nix
{
  pkgs,
  inputs,
  outputs,
  isTesting,
  ...
}:
let
  sharedPackages = import ./packages.nix { inherit pkgs; };
in
{
  imports = [
    ../common/linux
  ];

  _module.args = {
    user = "schmas";
  };

  networking = {
    hostName = "helka";
  };

  # It me
  # Set fish as the default shell
  users.knownUsers = [ "schmas" ];
  users.users.schmas = {
    home = "/home/schmas";
    uid = 501;
    isHidden = false;
    shell = pkgs.fish;
  };

  home-manager = {
    users = {
      schmas =
        {
          inputs,
          outputs,
          pkgs,
          ...
        }:
        {
          imports = [ ../../home/schmas/vesuvio.nix ];
        };
    };
  };

  environment.systemPackages = with pkgs; [
  ] ++ sharedPackages.all-packages;
}
