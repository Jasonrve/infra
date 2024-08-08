{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }: {

    nixosConfigurations = {
      nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix
          ./k3s.nix
        ];
      };
      test = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix
        ];
      };
    };

    homeConfigurations = {
      desktop = home-manager.lib.homeManagerConfiguration {
        inherit nixpkgs.legacyPackages.x86_64-linux;
        system = "x86_64-linux";
        modules = [
          ./home.nix
        ];
      };
    };
  };
}
