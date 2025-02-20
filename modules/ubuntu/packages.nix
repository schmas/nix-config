{ pkgs, isTesting ? false, ... }:

let
  # Ubuntu-specific packages
  ubuntuSpecificPackages = with pkgs; [ ];

  sharedPackages = import ../shared/packages.nix { inherit pkgs; };

  # Combine shared packages with Darwin-specific packages
  allPackages = sharedPackages ++ ubuntuSpecificPackages;

in {
  # System packages that are not in Homebrew
  environment.systemPackages = allPackages;
}
