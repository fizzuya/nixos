{ config, pkgs, ... }:

{
    services.xserver.videoDrivers = [ "nvidia" ];

    hardware.nvidia = {
    # Modesetting is strictly required for Wayland and DLSS initialization
    modesetting.enable = true;

    # Power management tracks state switches to prevent graphics crashes upon wake
    powerManagement.enable = false;
    powerManagement.finegrained = false;

    # Use the official proprietary drivers (Required for DLSS)
    open = false;

    # Pull the latest stable production branch driver
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };
}
