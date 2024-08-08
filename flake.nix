{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }: 
   let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      formatter.${system} = pkgs.alejandra;

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

      homeConfigurations.jason = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
  
        modules = [
          ./home.nix
        ];
      };
  };
}
