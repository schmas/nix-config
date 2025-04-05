{
  inputs,
  lib,
  config,
  ...
}:
let
  flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
in
{
  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
        "ca-derivations"
      ];
      warn-dirty = false;
      flake-registry = ""; # Disable global flake registry
    };

    gc = lib.mkIf config.nix.enable {
      automatic = true;
      interval = {
        Weekday = 1;
        Hour = 11;
        Minute = 0;
      };
      options = "--delete-older-than 30d";
    };

    # Add each flake input as a registry and nix_path
    registry = lib.mapAttrs (_: flake: { inherit flake; }) flakeInputs;
    nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;
  };

}
