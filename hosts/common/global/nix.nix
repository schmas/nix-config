{
  inputs,
  lib,
  ...
}:
let
  flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
in
{
  nix = {
    settings = {
      extra-substituters = lib.mkAfter [
        "https://cache.m7.rs"
        "https://cache.nixos.org"
        "https://nix-community.cachix.org"
        "https://tree-grepper.cachix.org"
      ];

      # cachix use tree-grepper -O /tmp/cachix-conf
      trusted-public-keys = [
        "cache.m7.rs:kszZ/NSwE/TjhOcPPQ16IuUiuRSisdiIwhKZCxguaWg="
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "tree-grepper.cachix.org-1:Tm/owXM+dl3GnT8gZg+GTI3AW+yX1XFVYXspZa7ejHg="
      ];

      trusted-users = [
        "root"
        "@wheel"
      ];

      experimental-features = [
        "nix-command"
        "flakes"
        "ca-derivations"
      ];
      warn-dirty = false;
      flake-registry = ""; # Disable global flake registry
    };

    gc = {
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
