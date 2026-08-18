{ config, pkgs, ... }:

let

    # either offlaod or sync
    primeconfig = sync;

    # configurable nvidia-offload
    # requires enableOffloadCmd = false; otherwise it will get overridden
    custom-offload = pkgs.writeShellScriptBin "nvidia-offload" ''
        export __NV_PRIME_RENDER_OFFLOAD=1
        export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
        export __GLX_VENDOR_LIBRARY_NAME=nvidia
        export __VK_LAYER_NV_optimus=NVIDIA_only
        export WINE_DISABLE_HARDWARE_SCHEDULING=0
        exec "$@"
    '';

    busses = {
        # Make sure to use the correct Bus ID values
        # sudo lshw -c display ; needs lshw
        # or
        # sudo lspci -nn | grep -i nvidia/amd/vga
        nvidiaBusId = "PCI:1:0:0";
        amdgpuBusId = "PCI:6:0:0";
    };

    # offload primarily uses iGPU and calls for dGPU when necessary
    offload = {
        inherit (busses) nvidiaBusId amdgpuBusId;

        offload = {
            enable = true;
            enableOffloadCmd = false; # false for custom-offload
        };
        sync.enable = false;
        reverseSync.enable = false;
    };

    # sync renders everything on dGPU and iGPU only copies things from it to output to a display
    # dGPU never sleeps while unneeded
    sync = {
        inherit (busses) nvidiaBusId amdgpuBusId;

        offload.enable = false;
        sync.enable = true;
        reverseSync.enable = false;
    };

    # same as sync but dGPU is the primary output device to things that are wired to it
    # not really needed for me i think but eh why not
    reverse-sync = {
        inherit (busses) nvidiaBusId amdgpuBusId;

        offload.enable = false;
        sync.enable = false;
        reverseSync.enable = true;
    };

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
    services.xserver.videoDrivers = [   # which video drivers to use in general
                                        # amdgpu / nvidia / some bullshit for intel i dont rembemer
        "amdgpu"
        "nvidia"
    ];

    hardware.nvidia = {
        # wayland stuff
        modesetting.enable = true;
        # sleep stuff i think
        nvidiaPersistenced = true;

        # open source or no
        open = false;
        prime = primeconfig;

        powerManagement.enable = true;      # Enable NVIDIA suspend/hibernate hooks (nvidia-suspend.service, etc.)
#         powerManagement.finegrained = false; # requires offload
        powerManagement.finegrained = if primeconfig.offload.enable then true else false; # requires offload

        nvidiaSettings = true;

        # driver package
        package = config.boot.kernelPackages.nvidiaPackages.stable; # bundled with kernel
#         package = pkgs.nvidia_cachyos; # cachy specifically

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
