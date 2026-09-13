{ config, pkgs, username, ... }:

{
    imports = [
        ./utils/peripherals.nix
    ];

    environment.systemPackages = with pkgs; [
        git
        home-manager

#         vscode-fhs # idk what fhs is tbh but vscode ig
        vscodium
        (python314.withPackages (ps: with ps; # Python Set to ensure all is from one package
            [
                tkinter
                pyqt6
                pillow
                ffmpeg-python
            ]
        ))
        gcc # The GNU Compiler Collection includes compiler front ends for C, C++, Objective-C, Fortran, OpenMP for C/C++/Fortran, and Ada, as well as libraries for these languages (libstdc++, libgomp,…).
        pkgsCross.mingw32.buildPackages.gcc # i needed these for something specific but don't remember what it was. maybe not needed. not gonna bother checking. maybe i was trying to make spore work?
        pkgsCross.mingwW64.buildPackages.gcc
        gnumake
        dotnetCorePackages.sdk_10_0-bin # to run vintagestory natively in lutris
        coreutils

        gnugrep
        pciutils # pci devices database type shit idk sth along the lines
        lshw
        wget
        busybox # a fuck ton of unix utils
                # lspci # is in there too which i need

        # thunar bc its gtk and firefox is gtk so i have an actual filepicker
        # that works well in both system and firefox portal filepicker call
        thunar

        # cant be bothered with managing kde right now so ill just throw some bullshit in here idc
        # TODO: replace these with non-kde variants that don't require to install an entire god damn DE
        kdePackages.kcalc
        kdePackages.kamoso
        kdePackages.kdenlive
        kdePackages.kate

#         btop # removed bc having it here fucks up custom wrapper in terminal.nix that gives path to the gpu akin to a command below:
                # ; LD_LIBRARY_PATH=/run/opengl-driver/lib btop
        caligula # image burning util so no need for dd if= of=
        switcheroo # image format converter
        _7zip-zstd
        unrar

        onlyoffice-desktopeditors

        wireguard-tools
        proton-vpn
        mullvad-vpn # "application" part of mullvad, needed so kde sees it as an app for example.
                    # vpn would work without it with gui but it'd need to be run with a terminal

    ];

    environment.sessionVariables = {
        DOTNET_ROOT = "${pkgs.dotnetCorePackages.runtime_10_0-bin}/share/dotnet"; # for vintagestory, dont forget to set custom in lutris game conf if running via wine
    };

    #enabling mullvad via service bc just adding package doesnt work, also making it have a gui
    services.mullvad-vpn = {
        enable = true;
        gui.enable = true;
    };
}
