{ config, pkgs, ... }:

{
    environment.systemPackages = with pkgs; [
        git
        home-manager

        openrgb
        logiops
        # keyd # no need to mention it because services.keyd does the job

#         vscode-fhs # idk what fhs is tbh but vscode ig
        (python314.withPackages (ps: with ps; # Python Set to ensure all is from one package
            [
                tkinter
                pyqt6
                pillow
                ffmpeg-python
            ]
        ))
        gcc # The GNU Compiler Collection includes compiler front ends for C, C++, Objective-C, Fortran, OpenMP for C/C++/Fortran, and Ada, as well as libraries for these languages (libstdc++, libgomp,…).
        pkgsCross.mingw32.buildPackages.gcc
        pkgsCross.mingwW64.buildPackages.gcc
        gnumake
        vscodium

        gnugrep
        pciutils # pci devices database type shit idk sth along the lines
        lshw
        wget
        busybox # a fuck ton of unix utils
                # lspci # is in there too which i need

        # thunar bc its gtk and firefox is gtk so i have an actual filepicker
        # that works well in both system and firefox portal filepicker call
        thunar
        kdePackages.kcalc
        btop
        gotop
        caligula # image burning util so no need for dd
        switcheroo # image format converter
        _7zip-zstd

        onlyoffice-desktopeditors

        wireguard-tools
        proton-vpn
        mullvad-vpn

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
    hardware.logitech.wireless.enable = true; # idk if necessary

    # for mouse rgb control
    services.hardware.openrgb = with pkgs;{
        package = pkgs.openrgb-with-all-plugins;
        enable = true;
        startupProfile = "/home/fizzu/.config/OpenRGB/pink-cyan.orp";
    };
    # restart openrgb on wakeup
    powerManagement.resumeCommands = ''
        ${pkgs.bash}/bin/bash -c '${pkgs.coreutils}/bin/sleep 3
        ${pkgs.systemd}/bin/systemctl restart openrgb.service'
    '';

    systemd.services.openrgb-restarter = with pkgs;{
        after = [ "post-resume.target" ];
        wantedBy = [ "post-resume.target" ];
        serviceConfig = {
            ExecStart = ''
            ${pkgs.bash}/bin/bash -c '${pkgs.coreutils}/bin/sleep 3
            ${pkgs.systemd}/bin/systemctl restart openrgb.service'
            '';
            Type = "oneshot";
        };
    };

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
}
