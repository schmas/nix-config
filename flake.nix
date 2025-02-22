{
  description = "My Nix configuration";

  nixConfig = {
    extra-substituters = [
      "https://cache.m7.rs"
      "https://cache.nixos.org"
      "https://nix-community.cachix.org"
      "https://tree-grepper.cachix.org"
    ];

    # cachix use tree-grepper -O /tmp/cachix-conf
    trusted-public-keys = [
      "cache.m7.rs:kszZ/NSwE/TjhOcPPQ16IuUiuRSisdiIwhKZCxguaWg="
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "tree-grepper.cachix.org-1:Tm/owXM+dl3GnT8gZg+GTI3AW+yX1XFVYXspZa7ejHg="
    ];
  };

  inputs = {
    # Nix ecosystem
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.11";
    systems.url = "github:nix-systems/default";

    hardware.url = "github:nixos/nixos-hardware";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Darwin-specific packages
    nix-darwin = {
      url = "github:LnL7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-homebrew = {
      url = "github:zhaofengli-wip/nix-homebrew";
    };
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

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      nix-darwin,
      nix-homebrew,
      homebrew-bundle,
      homebrew-core,
      homebrew-cask,
      mac-app-util,
      systems,
      ...
    }@inputs:
    let
      inherit (self) outputs;
      user = "schmas";
      lib = nixpkgs.lib // home-manager.lib // nix-darwin.lib;
      forEachSystem = f: lib.genAttrs (import systems) (system: f pkgsFor.${system});
      pkgsFor = lib.genAttrs (import systems) (
        system:
        import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        }
      );
    in
    {
      inherit lib;
      inherit user;
      nixosModules = import ./modules/nixos;
      darwinModules = import ./modules/darwin;
      homeManagerModules = import ./modules/home-manager;

      overlays = import ./overlays { inherit inputs outputs; };

      packages = forEachSystem (pkgs: import ./pkgs { inherit pkgs; });
      devShells = forEachSystem (pkgs: import ./shell.nix { inherit pkgs; });
      formatter = forEachSystem (pkgs: pkgs.alejandra);

      darwinConfigurations = {
        # Personal/Work laptop
        "vesuvio" = lib.darwinSystem {
          system = "aarch64-darwin";
          modules = [
            mac-app-util.darwinModules.default
            ./hosts/vesuvio
          ];
          specialArgs = { inherit inputs outputs; };
        };

        "vesuvio-test" = lib.darwinSystem {
          system = "aarch64-darwin";
          modules = [
            mac-app-util.darwinModules.default
            ./hosts/vesuvio
          ];
          specialArgs = {
            inherit inputs outputs;
            isTesting = true;
          };
        };

        # Work desktop
        # popos = lib.nixosSystem {
        #   modules = [ ./hosts/popos ];
        #   specialArgs = { inherit inputs outputs; };
        # };
      };

      # nixosConfigurations = {
      #   # Work desktop
      #   # popos = lib.nixosSystem {
      #   #   modules = [ ./hosts/popos ];
      #   #   specialArgs = { inherit inputs outputs; };
      #   # };
      # };

      # homeConfigurations = {
      #   # Standalone HM only
      #   # Work laptop
      #   "schmas@vesuvio" = lib.homeManagerConfiguration {
      #     modules = [
      #       mac-app-util.homeManagerModules.default
      #       ./home/schmas/macos.nix
      #       ./home/schmas/nixpkgs.nix
      #     ];
      #     pkgs = pkgsFor.aarch64-darwin;
      #     extraSpecialArgs = { inherit inputs outputs; };
      #   };

      #   # # Work desktop
      #   # "schmas@popos" = lib.homeManagerConfiguration {
      #   #   modules = [ ./home/schmas/popos.nix ./home/schmas/nixpkgs.nix ];
      #   #   pkgs = pkgsFor.x86_64-linux;
      #   #   extraSpecialArgs = { inherit inputs outputs; };
      #   # };
      # };
    };
}
