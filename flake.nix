{
  description = "Multi-system Nix configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nix-darwin = {
      url = "github:LnL7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-homebrew = { url = "github:zhaofengli-wip/nix-homebrew"; };
    homebrew-bundle = {
      url = "github:homebrew/homebrew-bundle";
      flake = false;
    };
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
    mac-app-util.url = "github:hraban/mac-app-util";
  };

  outputs = { self, nixpkgs, nix-darwin, home-manager, nix-homebrew
    , homebrew-bundle, homebrew-core, homebrew-cask, mac-app-util, ... }@inputs:
    let
      user = "schmas";

      mkDarwinSystem = { isTesting ? false }: nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        specialArgs = inputs // { inherit self user isTesting; };  # Pass isTesting
        modules = [
          ./hosts/darwin
          mac-app-util.darwinModules.default
          home-manager.darwinModules.home-manager
          {
            home-manager.extraSpecialArgs = { inherit user; };
            home-manager.sharedModules = [
                mac-app-util.homeManagerModules.default
              ];
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "backup";
            home-manager.users.${user} = { pkgs, lib, config, user, ... }:
              import ./modules/darwin/home-manager.nix { inherit pkgs lib user config; };
          }
        ];
      };

    in {
      darwinConfigurations = {
        "macos" = mkDarwinSystem { isTesting = false; };
        "macos-testing" = mkDarwinSystem { isTesting = true; };
      };

      nixosConfigurations."ubuntu" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = inputs // { inherit self user; };
        modules = [
          ./hosts/ubuntu
          home-manager.nixosModules.home-manager
          {
            home-manager.extraSpecialArgs = { inherit user; };
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "backup";
            home-manager.users.${user} = { pkgs, lib, config, user, ... }:
              import ./modules/ubuntu/home-manager.nix { inherit pkgs lib user config; };
          }
        ];
      };

      # Development shell with formatting tools
      devShells.x86_64-linux.default =
        let pkgs = nixpkgs.legacyPackages.x86_64-linux;
        in pkgs.mkShell { buildInputs = with pkgs; [ nixpkgs-fmt nil ]; };

      devShells.aarch64-darwin.default =
        let pkgs = nixpkgs.legacyPackages.aarch64-darwin;
        in pkgs.mkShell { buildInputs = with pkgs; [ nixpkgs-fmt nil ]; };
    };
}
