{
  description = "flake main ig idfk";

  inputs = {
    # default NixOS unstable branch
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    systems.url = "github:nix-systems/default";

    nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel";

    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs = { self, nixpkgs, systems, home-manager, spicetify-nix, chaotic, nix-cachyos-kernel, ... }@inputs: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [
        (
          { pkgs, ... }:
          {
            nixpkgs.overlays = [
              # Use the exact nixpkgs revision as defined in this repo to ensure binary cache hits.
              # to not compile kernel locally each time
#               nix-cachyos-kernel.overlays.pinned

              # Alternatively, use nixpkgs from your environment, nixpkgs.config will apply.
              # Note: may not hit binary cache; kernel will need to be built locally.
#               nix-cachyos-kernel.overlays.default

              # Only use one of the two overlays!
            ];
          }
        )
        # for cachyos kernel;
        chaotic.nixosModules.nyx-cache
        chaotic.nixosModules.nyx-overlay
        chaotic.nixosModules.nyx-registry

        ./configuration.nix
        ./hardware-configuration.nix

        ./functionality/kernel.nix
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
