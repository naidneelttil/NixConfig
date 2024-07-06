{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

     home-manager = {
       url = "github:nix-community/home-manager";
       inputs.nixpkgs.follows = "nixpkgs";
     };
     
     xremap-flake.url = "github:xremap/nix-flake";
     nixvim.url = "path:./modules/home-manager/nixvim/";

     };

  outputs = { self, nixpkgs, home-manager, xremap-flake, nixvim, ... }@inputs: 
    let 
       system = "x86_64-linux";
       pkgs = nixpkgs.legacyPackages.${system};
    
    in	
    {
    
    nixosConfigurations.default = nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs;};
      modules = [
        ./hosts/default/configuration.nix
        inputs.home-manager.nixosModules.default
        #./hosts/default/home.nix	
      ];
    };
  };
}
