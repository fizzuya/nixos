{ config, pkgs, lib, username, ... }:

let
    desktop-type = "kde"; # kde or hypr # does nothing bc its defined with a mySystem variable in flake
in
{
    imports = [
         ./hypr/hypr.nix
         ./kde/kde.nix
         ./portals/xdg-portals.nix
    ];

    config = {
        # noctalia variable config.mySystem.noctalia-enable in flake




        ###### NOTE: PULLED FROM THE DEFAULT configuration.nix ######

        # Set your time zone.
        time.timeZone = "Europe/Copenhagen";

        # Select internationalisation properties.
        i18n.defaultLocale = "en_US.UTF-8";

        i18n.extraLocaleSettings = {
            LC_ADDRESS = "da_DK.UTF-8";
            LC_IDENTIFICATION = "da_DK.UTF-8";
            LC_MEASUREMENT = "da_DK.UTF-8";
            LC_MONETARY = "da_DK.UTF-8";
            LC_NAME = "da_DK.UTF-8";
            LC_NUMERIC = "da_DK.UTF-8";
            LC_PAPER = "da_DK.UTF-8";
            LC_TELEPHONE = "da_DK.UTF-8";
            LC_TIME = "da_DK.UTF-8";
        };
    };
}
