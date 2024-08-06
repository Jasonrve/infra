{
  description = "A NixOS configuration for k3s";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    ./k3s.nix;
  };

  outputs = { self, nixpkgs, nixos-hardware }: {
    nixosConfigurations = {
      my-hostname = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./k3s.nix
        ];
      };
    };
  };
}
