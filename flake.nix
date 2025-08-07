{
  description = "Nixos config flake for StoutPanda";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    #lix import
    lix-module = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/2.93.3-1.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    #point everything to my home-manager flake
    home-manager-config.url = "github:stoutpanda/home-manager";
    home-manager.follows = "home-manager-config/home-manager";
    #chotic nyx!
    chaotic.follows = "home-manager-config/chaotic";
    #nixos hardware
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    agenix.follows = "home-manager-config/agenix";
  };
  outputs =
    {
      self,
      nixpkgs,
      lix-module,
      nixos-hardware,
      home-manager,
      home-manager-config,
      chaotic,
      agenix,
      ...
    }@inputs:
    let
      # Helper function for multi-system support
      forAllSystems = nixpkgs.lib.genAttrs nixpkgs.lib.systems.flakeExposed;
    in
    {
      nixosConfigurations.nixos-whitedwarf = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [
          lix-module.nixosModules.default
          {
            nixpkgs.overlays = [ chaotic.overlays.default ];
            nixpkgs.hostPlatform = "x86_64-linux";
          }
          agenix.nixosModules.default
          ./configuration.nix
          ./hosts/nixos-whitedwarf/configuration.nix

        ];
      };

      # Formatter for nix files
      formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.nixpkgs-fmt);

      # Checks to run
      checks = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          format = pkgs.runCommand "check-format" { } ''
            ${pkgs.nixpkgs-fmt}/bin/nixpkgs-fmt --check ${./.}
            touch $out
          '';
        }
      );
    };
}
