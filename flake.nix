{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
  };

  outputs = { self, nixpkgs, ... }: {

  nixosSystem:
      nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix
          ./k3s.nix
        ];
      };
  nixosSystem2:
      nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix
        ];
      };

    nixosConfigurations = {
      nixos = nixosSystem;
      test = nixosSystem2;
    };
  };
}
