# This file should be included when using hm standalone
{ outputs, lib, inputs, ... }:
let flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
in {
  nix = {
    settings = {
      # extra-substituters = lib.mkAfter [
      #   "https://cache.nixos.org"
      #   "https://nix-community.cachix.org"
      #   "https://tree-grepper.cachix.org"
      # ];
      # extra-trusted-public-keys = [
      #   "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      #   "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      #   "tree-grepper.cachix.org-1:Tm/owXM+dl3GnT8gZg+GTI3AW+yX1XFVYXspZa7ejHg="
      # ];
      experimental-features = [ "nix-command" "flakes" "ca-derivations" ];
      warn-dirty = false;
      flake-registry = ""; # Disable global flake registry
    };
    registry = lib.mapAttrs (_: flake: { inherit flake; }) flakeInputs;
  };

  home.sessionVariables = {
    NIX_PATH = lib.concatStringsSep ":"
      (lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs);
  };

  nixpkgs = {
    overlays = builtins.attrValues outputs.overlays;
    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
    };
  };
}
