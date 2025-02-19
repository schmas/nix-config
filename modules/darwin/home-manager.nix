{ user, config, pkgs, ... }:

let
  commonAliases = {
    update-nix = "git -C ~/.config/dotfiles_nix pull && darwin-rebuild switch --flake ~/.config/dotfiles_nix#macos";
    update-nix-test = "git -C ~/.config/dotfiles_nix pull && darwin-rebuild switch --flake ~/.config/dotfiles_nix#macos-testing";
  };
in
{
  imports = [ ../shared/home-manager.nix ];

  # homeDirectory = "/Users/${user}";

  # Darwin-specific packages
  # home.packages = with pkgs; [
  #   coreutils
  #   gnused
  #   iterm2
  # ];

  # Darwin-specific program configurations
  # programs = {
  #   alacritty = {
  #     enable = true;
  #     settings = {
  #       # Your Alacritty settings here
  #     };
  #   };
  # };

  # Any other Darwin-specific configurations

  programs = {
    bash.shellAliases = commonAliases;
    zsh.shellAliases = commonAliases;
    fish.shellAliases = commonAliases;
  };
}
