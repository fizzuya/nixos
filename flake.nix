{
  description = "flake main ig idfk";

  inputs = {
    # default NixOS unstable branch
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    systems.url = "github:nix-systems/default";

    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs: {
        # "nixos" is the hostname, change appropriately
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./configuration.nix
        ./hardware-configuration.nix

        ./functionality/bluetooth.nix
        ./functionality/partitions.nix
        ./functionality/nvidia.nix
#         ./functionality/modules.nix

        ./apps/gaming.nix
        ./apps/browser.nix
        ./apps/terminal.nix
        ./apps/utils.nix
        ./apps/media.nix


        ./home.nix
        home-manager.nixosModules.home-manager
        {
        home-manager.extraSpecialArgs = { inherit inputs; };
        }
      ];
    };
  };
}
