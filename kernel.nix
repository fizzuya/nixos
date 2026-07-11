{ config, pkgs, ... }:

{

#     linux kernel:
    boot.kernelPackages = pkgs.linuxPackages_latest;
    boot.kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-latest;
    boot.kernelPackages = inputs.nix-cachyos-kernel.legacyPackages.${pkgs.system}.linuxPackages-cachyos-latest;

    substituters = [ "https://drakon64-nixos-cachyos-kernel.cachix.org" ];
    trusted-public-keys = [ "drakon64-nixos-cachyos-kernel.cachix.org-1:J3gjZ9N6S05pyLA/P0M5y7jXpSxO/i0rshrieQJi5D0=" ];
    networking.hostName = "nixos"; # Define your hostname.


}
