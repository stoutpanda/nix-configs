{
  description = "Nixos config flake for StoutPanda";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    #lix import 
    lix-module = {
	url = "https://git.lix.systems/lix-project/nixos-module/archive/2.93.2-1.tar.gz";
	inputs.nixpkgs.follows = "nixpkgs";

	};
    #point everything to my home-manager flake
     home-manager-config.url = "github:stoutpanda/home-manager";
     home-manager.follows = "home-manager-config/home-manager";
     #chotic nyx!
     chaotic.follows = "home-manager-config/chaotic";
     #nixos hardware
     nixos-hardware.url = "github:NixOS/nixos-hardware/maaster";         

};

  outputs = { self, nixpkgs, lix-module, home-manager, home-manager-config, chaotic, nixos-hardware,  ... }@inputs: {
    nixosConfigurations.nixos-whitedwarf = nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs;};
      modules = [
	lix-module.nixosModules.default
	nikpkgs.overlays = [ chaotic.overlays.default ];
        ./configuration.nix
        ./hosts/${hostname}/configuration.nix
        nixosModules.default.home-manager {
		home-manager.useGlobalPkgs = true;
		home-manager.useUserPackages = true;
		home-manager.extraSpecialArgs = { inherit inputs; };	
		home-manager.users.jason = home-manager-config.homeConfiguration.jason.config;
		home-manager.backupFileExtension = "backup";
	}

      ];
    };
  };
}
