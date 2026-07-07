{ config, pkgs, ... }:

{
    nixpkgs.config.allowUnfree = true;

    services.xserver.videoDrivers = [ "nvidia" ];

    hardware.nvidia = {
        modesetting.enable = true;

        powerManagement.enable = true;      # Enable NVIDIA suspend/hibernate hooks (nvidia-suspend.service, etc.)
#         powerManagement.finegrained = true; # Fine-grained power management (recommended for Turing+ GPUs, Optimus setups)


        # production stable driver package
        package = config.boot.kernelPackages.nvidiaPackages.stable;
        # proprietary driver (for DLSS)
        open = false;

#         prime = {
#             # Make sure to use the correct Bus ID values for your system!
#             # sudo lshw -c display ; needs lshw
# #                 intelBusId = "PCI:0:2:0";
#                 nvidiaBusId = "PCI:14:0:0";
#                 amdgpuBusId = "PCI:54:0:0";
#         };

    };

    # force kernel to load modesetting arguments early in the boot cycle
    boot.initrd.kernelModules = [ "nvidia" "nvidia_modeset" "nvidia_uvm" "nvidia_drm" ];
    boot.kernelParams = [
        # Prefer suspend-to-RAM (S3 "deep") over s2idle, for lower power usage and stability
        "mem_sleep_default=deep"
        # (Optional) Prevent spurious wake-ups from EC (uncomment if you have immediate wake issues)
        "acpi.ec_no_wakeup=1"

        "nvidia-drm.modeset=1"
        "nvidia.NVreg_PreserveVideoMemoryAllocations=1"
        "nvidia.NVreg_TemporaryFilePath=/var/tmp"
    ];

    # If hibernation is desired, make sure swap is set and resume device is specified:
#     swapDevices = [ { device = "/dev/disk/by-uuid/<YOUR-SWAP-UUID>"; } ];
#     boot.resumeDevice = "/dev/disk/by-uuid/<YOUR-SWAP-UUID>";

    # (Optional) Workaround for systemd user session freeze hang:
    systemd.services."systemd-suspend".environment.SYSTEMD_SLEEP_FREEZE_USER_SESSIONS = "false";



}
