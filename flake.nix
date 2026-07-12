{
  description = "flake main ig idfk";

  inputs = {
    # default NixOS unstable branch
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
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

  outputs = { self, nixpkgs, systems, nix-cachyos-kernel, home-manager, spicetify-nix, ... }@inputs: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        (
          { pkgs, ... }:
          {
            nixpkgs.overlays = [
              # Use the exact nixpkgs revision as defined in this repo to ensure binary cache hits.
              nix-cachyos-kernel.overlays.pinned

              # Alternatively, use nixpkgs from your environment, nixpkgs.config will apply.
              # Note: may not hit binary cache; kernel will need to be built locally.
              # nix-cachyos-kernel.overlays.default

              # Only use one of the two overlays!
            ];
            boot.kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-latest;

            # ... your other configs
          }
        )

        ./configuration.nix
        ./hardware-configuration.nix
#         ./kernel.nix

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
