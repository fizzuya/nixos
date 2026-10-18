{
    description = "flake config";

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
        noctalia = {
            url = "github:noctalia-dev/noctalia/cachix"; # cached one
#             url = "github:noctalia-dev/noctalia";
#             inputs.nixpkgs.follows = "nixpkgs"; # this line is optional, prevents downloading two versions of nixpkgs but disables cache
        };


    };

    outputs = { self, nixpkgs, systems, home-manager, spicetify-nix, chaotic, nix-cachyos-kernel, ... }@inputs:
    let
        username = "fizzu";
        hostname = "nixos";

            # params which have different variants.
            # need to manually plug them in inside other files accordingly to what u want but it's easier to manage everything from here
        kernels = [ "latest" "cachy" ];
        desktop-types = [ "kde" "hypr" ];
        nvidia-drivers = [ "kernel" "cachy" ];
        nvidia-primes = [ "offload" "sync" "reverse-sync" ];

        # function to generate a specific system combination
        makeSystem = kernel: desktop: driver: prime: {
            name = "${kernel}-${desktop}-${driver}-${prime}";
            value = nixpkgs.lib.nixosSystem {
                system = "x86_64-linux";
                specialArgs = { inherit inputs; username = "${username}"; hostname = "${hostname}"; };
                modules = [
                    (
                        { lib, ... }: {
                            config.mySystem = {
                                kernel-type = kernel;
                                desktop-type = desktop;
                                nvidia-driver-package = driver;
                                nvidia-primeconfig = prime;
#                                 noctalia-enable = true;
                            };

                            options.mySystem = {
                                kernel-type = with lib; mkOption {
                                    type = types.enum kernels;
                                    default = "latest";
                                    description = "kernel variant: ${kernels}";
                                };

                                desktop-type = with nixpkgs.lib; mkOption {
                                    type = types.enum desktop-types;
                                    default = "kde";
                                    description = "pick your poison (DE): ${desktop-types}";
                                };

                                nvidia-driver-package = with nixpkgs.lib; mkOption {
                                    type = types.enum nvidia-drivers;
                                    default = "kernel";
                                    description = "nvidia driver type: bundled with kernel, cachy, or whatever else i might add in the future thats not there yet";
                                };

                                nvidia-primeconfig = with nixpkgs.lib; mkOption {
                                    type = types.enum nvidia-primes;
                                    default = "offload";
                                    description = "primeconfig for nvidia graphics card: ${nvidia-primes}";
                                };

                                noctalia-enable = with nixpkgs.lib; mkOption {
                                    type = types.bool;
                                    default = true;
                                    description = "if noctalia should be enabled /// not used in system making action";
                                };
                            };
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
                    ./functionality/graphics.nix

                    ./desktop/desktop.nix

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

        # generate list of permutations
        allPermutations = nixpkgs.lib.flatten (
        map (kernel:
            map (desktop:
                map (driver:
                    map (prime: makeSystem kernel desktop driver prime) nvidia-primes
                    ) nvidia-drivers
                ) desktop-types
            ) kernels
        );

    in
    {
        nixosConfigurations = (builtins.listToAttrs allPermutations) // {
            "${hostname}" = (builtins.listToAttrs allPermutations)."latest-kde-kernel-offload"; # default fallback if no specified
        };
    };
}
