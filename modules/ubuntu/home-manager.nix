{ user, config, pkgs, ... }:

let
  commonAliases = {
    update-nix = "git -C ~/.config/dotfiles_nix pull && nixos-rebuild switch --flake ~/.config/dotfiles_nix#ubuntu";
    update-nix-test = "git -C ~/.config/dotfiles_nix pull && nixos-rebuild test --flake ~/.config/dotfiles_nix#ubuntu";
    update-nix-boot = "git -C ~/.config/dotfiles_nix pull && nixos-rebuild boot --flake ~/.config/dotfiles_nix#ubuntu";
  };
in
{
  imports = [ ../shared/home-manager.nix ];

  # TODO

  # home.homeDirectory = "/home/${user}";

  # Ubuntu-specific packages
  # home.packages = with pkgs; [ gnome-tweaks ubuntu-drivers-common ];

  # Ubuntu-specific program configurations
  # programs = {
  #   vscode = {
  #     enable = true;
  #     extensions = with pkgs.vscode-extensions;
  #       [
  #         # Your VSCode extensions here
  #       ];
  #   };
  # };

  # Any other Ubuntu-specific configurations

  programs = {
    bash.shellAliases = commonAliases;
    zsh.shellAliases = commonAliases;
    fish.shellAliases = commonAliases;
  };
}
