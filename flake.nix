{
  description = "My Nix configuration";

  inputs = {
    # Nix ecosystem
    # nix.url = "https://flakehub.com/f/DeterminateSystems/nix/*";

    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/3";
    fh.url = "https://flakehub.com/f/DeterminateSystems/fh/*";

    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.05";

    # nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/*";
    # nixpkgs-stable.url = "https://flakehub.com/f/NixOS/nixpkgs/0.2411.*";

    # Systems
    systems.url = "github:nix-systems/default";
    hardware.url = "github:nixos/nixos-hardware";

    home-manager = {
      url = "github:nix-community/home-manager";
      # url = "https://flakehub.com/f/nix-community/home-manager/*";
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
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
    mac-app-util.url = "github:hraban/mac-app-util";
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-stable,
      determinate,
      fh,
      home-manager,
      nix-darwin,
      nix-homebrew,
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
            determinate.darwinModules.default
            mac-app-util.darwinModules.default
            ./hosts/vesuvio
          ];
          specialArgs = {
            inherit inputs outputs;
          };
        };
      };

      nixosConfigurations = {
        # Work desktop
        helka = lib.nixosSystem {
          system = "aarch64-linux";
          modules = [ ./hosts/helka ];
          specialArgs = { inherit inputs outputs; };
        };
      };

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
