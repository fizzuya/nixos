{
  description = "flake main ig idfk";

  inputs = {
    # default NixOS unstable branch
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    systems.url = "github:nix-systems/default";
    nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel";

    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs = { self, nixpkgs, nix-cachyos-kernel, home-manager, ... }@inputs: {
        # "nixos" is the hostname, change appropriately
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        # CachyOS kernel
#         {
#           nixpkgs.overlays = [ nix-cachyos-kernel.overlays.default ];
#         }

        ./configuration.nix
        ./hardware-configuration.nix

        ./functionality/bluetooth.nix
        ./functionality/partitions.nix
        ./functionality/nvidia.nix

        ./apps/gaming.nix
        ./apps/browser.nix
        ./apps/terminal.nix
        ./apps/utils.nix
        ./apps/media.nix
        ./apps/autostart.nix


        ./home.nix
        home-manager.nixosModules.home-manager
        {
        home-manager.extraSpecialArgs = { inherit inputs; };
        }
      ];
    };
  };
}
