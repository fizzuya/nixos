{ config, pkgs, username, ... }:

let
    openrgb-profile = "pink-cyan";
in
{
    environment.systemPackages = with pkgs; [
#         openrgb # already in imported openrgb.nix conf
        logiops
        keyd
        logitech-udev-rules
    ];

    # importing all the openrgb handling in the world in its own file in its own folder bc openrgb is a bitch and wants a whole ass script after the evil update
    imports =
    [
        (import ./OpenRGB/openrgb.nix { profile-name = "${openrgb-profile}"; })
    ];

    # NUKING the FUCK out of STUPID copilot key
    services.keyd = {
        enable = true;
        keyboards = {
            copilot = {
                ids = [ "*" ]; # keyboard id, eh
                settings = {
                    main = {
                        "leftmeta+leftshift+f23" = "layer(control)";
                    };
                };
            };
        };
    };

    # adds logitech stuff stuff so mouse can be controlled
    # like pkgs.logitech-udev-rules
    hardware.logitech.wireless.enable = true; # idk if necessary or if does anything

    # configure existing logiops service to use wanted dpi
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
