{ inputs, lib, pkgs, config, outputs, home-base-dir ? "home", ... }: {
  imports = [ ] ++ (builtins.attrValues outputs.homeManagerModules);

  nix = {
    package = lib.mkDefault pkgs.nix;
    settings = {
      experimental-features = [ "nix-command" "flakes" "ca-derivations" ];
      warn-dirty = false;
    };
  };

  systemd.user.startServices = "sd-switch";

  programs = {
    home-manager.enable = true;
    # git.enable = true;
  };

  home = {
    username = lib.mkDefault "${outputs.user}";
    homeDirectory = lib.mkDefault "/${home-base-dir}/${config.home.username}";
    stateVersion = lib.mkDefault "25.05";
    sessionPath = [ "$HOME/.local/bin" ];
    # sessionVariables = { FLAKE = "$HOME/Documents/NixConfig"; };
  };

  home.packages = with pkgs; [];
}
