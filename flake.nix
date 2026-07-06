{
  description = "naidneelttil's nixos config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable"; 
    disko.url = "github:nix-community/disko";

     home-manager = {
       url = "github:nix-community/home-manager/release-26.05";
       inputs.nixpkgs.follows = "nixpkgs";
       };
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, disko, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs-unstable = import nixpkgs-unstable { inherit system; config.allowUnfree = true; };
    in {
    # use "nixos", or your hostname as the name of the configuration
    # it's a better practice than "default" shown in the video
    nixosConfigurations.laptop = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs pkgs-unstable; };
      modules = [
        ./hosts/laptop/configuration.nix
         inputs.home-manager.nixosModules.default
      ];
    };

    nixosConfigurations.desktop = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs pkgs-unstable; };
      modules = [
       
        ./hosts/desktop/configuration.nix
        ./hosts/desktop/disko-config.nix
        disko.nixosModules.disko  
        inputs.home-manager.nixosModules.default {
           home-manager.users.naidneelttil = import ./home.nix;
	}

      ];
    };





  };
}
