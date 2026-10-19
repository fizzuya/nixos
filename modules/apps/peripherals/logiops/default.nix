{ config, pkgs, username, ... }:

let
    openrgb-profile = "pink-cyan";
in
{
    environment.systemPackages = with pkgs; [
#         openrgb # already in imported openrgb.nix conf
        logiops
        logitech-udev-rules
    ];

    # adds logitech stuff stuff so mouse can be controlled
    # like pkgs.logitech-udev-rules
    hardware.logitech.wireless.enable = true; # idk if necessary or if does anything

    # configure existing logiops service to use desired dpi
    services.logiops = {
        enable = true;
        config = {
            devices = [
                {
                name = "G203 LIGHTSYNC Gaming Mouse";
                dpi = 1100;
                }
            ];
        };
    };
}
