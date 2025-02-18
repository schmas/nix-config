{ pkgs, ... }:

let
  # Additional Darwin-specific packages
  darwinSpecificPackages = with pkgs; [ dockutil ];

  sharedPackages = import ../shared/packages.nix { inherit pkgs; };
  homebrewPackages = import ./homebrew-packages.nix { inherit pkgs; };

  # Combine shared packages with Darwin-specific packages
  allPackages = sharedPackages.environment.systemPackages
    ++ darwinSpecificPackages;

  # Get the list of Homebrew package names
  homebrewPackageNames = homebrewPackages.homebrew.brews;

  # Filter out packages that are in Homebrew from all packages
  filteredPackages = builtins.filter
    (pkg: !(builtins.elem (pkg.pname or pkg.name) homebrewPackageNames))
    allPackages;

in {
  # System packages that are not in Homebrew
  environment.systemPackages = filteredPackages;
}
