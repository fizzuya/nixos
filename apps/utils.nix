{ config, pkgs, ... }:

{
    environment.systemPackages = with pkgs; [
        git
        home-manager

#         solaar
#         piper
        openrgb
        logiops
        # keyd no need to mention it because services.keyd does the job for whatever reason

        vscode-fhs
        python3
        python314
        python314Packages.pyqt6
        tk # tkinter
        gcc
        _7zip-zstd
    ];

    # adds logitech stuff stuff so mouse can be controlled
    # like pkgs.logitech-udev-rules
    hardware.logitech.wireless.enable = true; # idk if necessary

    # for mouse rgb control
    services.hardware.openrgb = with pkgs;{
        enable = true;
        startupProfile = "/home/fizzu/.config/OpenRGB/pink-cyan.orp";
    };

    # configure existing logiops service to use wanted dpi
    services.logiops = {
        enable = true;
        config = {
            devices = [
                {
                name = "G203 LIGHTSYNC Gaming Mouse";
                dpi = 1000;
                }
            ];
        };
    };

    # FUUUUUUUUUUUUUUUUUUUUUUCK THAT THING ABOVE WORKS INSTEAD OF THIS VILE DOGSHIT UUUUUUUUUGH
    # make a service that controls rgb with more user-agency but i fucked it up somehow somewhere probably in packages
#     systemd.services.mouse-rgb = {
#         after = [ "openrgb.service" ];
#         wants = [ "openrgb.service" ];
#         wantedBy = [ "multi-user.target" ];
#         serviceConfig = {
#             Type = "oneshot";
#             RemainAfterExit = true;
#             ExecStart = [
#             "${pkgs.coreutils}/bin/sleep 3"
#             "${pkgs.openrgb}/bin/openrgb --client 127.0.0.1 --device \"G203 LIGHTSYNC\" --mode static --profile /home/fizzu/.config/OpenRGB/pink-cyan.orp"
#             ];
#         };
#     };

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
}
