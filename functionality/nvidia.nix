{ config, pkgs, ... }:


# configurable nvidia-offload
# requires enableOffloadCmd = false; otherwise it will get overridden
let
    custom-offload = pkgs.writeShellScriptBin "nvidia-offload" ''
        export __NV_PRIME_RENDER_OFFLOAD=1
        export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
        export __GLX_VENDOR_LIBRARY_NAME=nvidia
        export __VK_LAYER_NV_optimus=NVIDIA_only
        export WINE_DISABLE_HARDWARE_SCHEDULING=0
        exec "$@"
    '';
in
{
    nixpkgs.config.allowUnfree = true;

    # Required for modern gaming performance (Vulkan, MangoHud, etc.)
    hardware.graphics = {
        enable = true;
        enable32Bit = true;
        extraPackages = with pkgs; [
        ];
    };

    environment.systemPackages = with pkgs; [
        nvtopPackages.nvidia
        mesa
        vulkan-loader
        vulkan-tools

        libva
        libva-utils

        custom-offload
    ];


    # for offload,, i guess
    # https://nixos.wiki/wiki/Nvidia
    services.xserver.videoDrivers = [
        "amdgpu"  # example for Intel iGPU; use "amdgpu" here instead if your iGPU is AMD
        "nvidia"
    ];

    hardware.nvidia = {
        modesetting.enable = true;
        nvidiaPersistenced = true;

        powerManagement.enable = true;      # Enable NVIDIA suspend/hibernate hooks (nvidia-suspend.service, etc.)
        powerManagement.finegrained = true; # Fine-grained power management (recommended for Turing+ GPUs, Optimus setups)

        nvidiaSettings = true;


        # driver package
#         package = config.boot.kernelPackages.nvidiaPackages.stable;
        package = config.boot.kernelPackages.nvidiaPackages.stable;

        # open source or no (better be yes)
        open = true;

        # either offlaod or sync
        prime = {
            # Make sure to use the correct Bus ID values
            # sudo lshw -c display ; needs lshw
            # or
            # sudo lspci -nn | grep -i nvidia/amd/vga
            nvidiaBusId = "PCI:1:0:0";
            amdgpuBusId = "PCI:6:0:0";

            offload = {
                enable = true;
                enableOffloadCmd = false;
            };

            sync = {
                enable = false;
            };

        };
    };


    # force kernel to load modesetting arguments early in the boot cycle
    boot.initrd.kernelModules = [ "nvidia" "nvidia_modeset" "nvidia_uvm" "nvidia_drm" ];
    boot.kernelParams = [
        "mem_sleep_default=deep"
        # (Optional) Prevent spurious wake-ups from EC (uncomment if you have immediate wake issues)
        "acpi.ec_no_wakeup=1"

        "nvidia-drm.modeset=1"
        "nvidia.NVreg_PreserveVideoMemoryAllocations=1"
        "nvidia.NVreg_TemporaryFilePath=/var/tmp"
        "nvidia-drm.fbdev=1" # for KDE Plasma Wayland integration but honestly no clue lmao

        # for cachyos kernel compatibility its supposed to be 0 but idfk
        "nvidia.NVreg_EnableGpuFirmware=1"
    ];

    # (Optional) Workaround for systemd user session freeze hang:
    systemd.services."systemd-suspend".environment.SYSTEMD_SLEEP_FREEZE_USER_SESSIONS = "false";
}
