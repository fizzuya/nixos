{ config, pkgs, inputs, ... }:
let
cachykernel = inputs.nix-cachyos-kernel.cachyosKernels.linuxPackages-cachyos-latest;
linuxlatest = pkgs.linuxPackages_latest;
linux_7_1_4 = pkgs.linuxPackagesFor (pkgs.linux_7_1.override {
            argsOverride = rec {
                src = pkgs.fetchurl {
                        url = "mirror://kernel/linux/kernel/v7.x/linux-${version}.tar.xz";
                        sha256 = "0blfl34vi6vlcdjxd7mbhskl2p7i0zpgdy707a7d6xcn24m94qqw";
            };
            version = "7.1.4"; # nix-prefetch-url mirror://kernel/linux/kernel/v7.x/linux-7.1.4.tar.xz
            modDirVersion = "7.1.4";
            };
        });
in
{
    boot.kernelPackages = linux_7_1_4;
}
