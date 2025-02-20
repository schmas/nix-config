{ user, pkgs, ... }:

{
  # Do not import packages here, but in the host-specific configurations.
  imports = [ ./fonts.nix ];

  nix = {
    settings.experimental-features = [ "nix-command" "flakes" ];
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
