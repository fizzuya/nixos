{ config, pkgs, lib, ... }:

lib.mkIf (config.mySystem.desktop-type == "kde") {
    # Enable the KDE Plasma Desktop Environment.
    services.displayManager.sddm.enable = true;
    services.desktopManager.plasma6.enable = true;
}
