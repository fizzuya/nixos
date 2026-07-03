{ config, pkgs, ... }:

{
    nixpkgs.config.allowUnfree = true;

    services.xserver.videoDrivers = [ "nvidia" ];

    hardware.nvidia = {
        # wayland bs
        modesetting.enable = true;

        powerManagement.enable = false;
        powerManagement.finegrained = false;

        # proprietary driver (for DLSS)
        open = false;

        # production stable driver package
        package = config.boot.kernelPackages.nvidiaPackages.stable;
    };

    # force kernel to load modesetting arguments early in the boot cycle
    boot.initrd.kernelModules = [ "nvidia" "nvidia_modeset" "nvidia_uvm" "nvidia_drm" ];
    boot.kernelParams = [ "nvidia-drm.modeset=1" "nvidia.NVreg_PreserveVideoMemoryAllocations=1" ];
}
