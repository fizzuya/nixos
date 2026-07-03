{ config, pkgs, ... }:

{
    environment.systemPackages = with pkgs; [
        git
        home-manager

#         solaar
#         piper
        openrgb-with-all-plugins
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

    # stuff so mouse can be controlled
    hardware.logitech.wireless.enable = true; # idk if necessary
    services.udev.packages = with pkgs; [
        logitech-udev-rules
#         solaar
    ];
    # for mouse rgb control
    services.hardware.openrgb = with pkgs;{
        package = pkgs.openrgb-with-all-plugins;
        enable = true;
    };

    # make a service that controls rgb
    systemd.user.services.g203-mouse-rgb-config = {
        after = [ "openrgb.service" ];
        wants = [ "openrgb.service" ];
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
            Type = "oneshot";
            RemainAfterExit = true;
            ExecStart = "${pkgs.bash}/bin/bash -c '${pkgs.coreutils}/bin/sleep 3 && ${pkgs.openrgb}/bin/openrgb --client 127.0.0.1 --device \"G203 LIGHTSYNC\" --mode static --color 50D5E8,FF0055,50D5E8'";
#             ExecStart = "${pkgs.openrgb}/bin/openrgb --client 127.0.0.1 --device 'G203 LIGHTSYNC' --mode static --color 50D5E8,FF0055,50D5E8";
#             ExecStart = "${pkgs.openrgb}/bin/openrgb --device 'G203 LIGHTSYNC' --mode static --color 50D5E8,FF0055,50D5E8";
        };
    };

    # configure existing logiops service to use wanted dpi
    services.logiops.config = {
        enable = true;
        devices = [
            {
            name = "G203 LIGHTSYNC Gaming Mouse";
            dpi = 1000;
            }
        ];
    };

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
