{ user, config, pkgs, lib, isTesting ? false, ... }:

let
  commonAliases = {
    update-nix = "git -C ~/.config/dotfiles_nix pull && darwin-rebuild switch --flake ~/.config/dotfiles_nix#macos";
    update-nix-test = "git -C ~/.config/dotfiles_nix pull && darwin-rebuild switch --flake ~/.config/dotfiles_nix#macos-testing";
  };

  darwinPackages = pkgs.callPackage ./packages.nix { inherit isTesting; };
in
{
  imports = [ ../shared/home-manager.nix ];

  home.packages = darwinPackages.packages;

  programs = {
    bash.shellAliases = commonAliases;
    zsh.shellAliases = commonAliases;
    fish.shellAliases = commonAliases;
  };
}
