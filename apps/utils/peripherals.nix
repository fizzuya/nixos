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

    services.keyd = {
        enable = true;
        keyboards = {
            default = {
                ids = [ " 0001:0001:6fb3735a " ]; # keyboard id, * for all
                settings = let
                    # NUKING the FUCK out of STUPID copilot key
                    copilot = {
                            main = {
                                "leftmeta+leftshift+f23" = "layer(control)";
                            };
                    };

                    dead_row_bandaid = {
                            main = {
                                "delete" = "backspace";
                                "calc" = "delete";
                                "insert" = "numlock";
                                "kpenter" = "enter";
                            };
                    };
                in pkgs.lib.recursiveUpdate copilot dead_row_bandaid; # merges the 2 into one file

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
