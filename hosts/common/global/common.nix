{ inputs, outputs, pkgs, lib, ... }:
{
  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" "ca-derivations" ];
      allowed-users = [ "${outputs.user}" ];
      trusted-users = [ "@admin" "${outputs.user}" ];
      extra-substituters = [
        "https://cache.nixos.org"
        "https://nix-community.cachix.org"
        "https://tree-grepper.cachix.org"
      ];

      # cachix use tree-grepper -O /tmp/cachix-conf
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "tree-grepper.cachix.org-1:Tm/owXM+dl3GnT8gZg+GTI3AW+yX1XFVYXspZa7ejHg="
      ];

      sandbox = "relaxed"; # esplanade (rust-skia)
    };

    gc = {
      automatic = true;
      interval = {
        Weekday = 0;
        Hour = 0;
        Minute = 0;
      };
      options = "--delete-older-than 30d";
    };
  };

  nixpkgs = {
    overlays = builtins.attrValues outputs.overlays;
    config = {
      allowUnfree = true;
      allowBroken = true;
      allowInsecure = false;
      allowUnsupportedSystem = true;
    };
  };

  # Some packages might require additional configuration, for example:
  programs.bash.enable = true;
  programs.zsh.enable = true;
  programs.fish.enable = true;
}
