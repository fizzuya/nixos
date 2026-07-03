{ config, pkgs, ... }:

{
    environment.systemPackages = with pkgs; [
        git
        home-manager

        solaar
        # keyd no need to mention it because services.keyd does the job for whatever reason

        vscode-fhs
        python3
        python314
        python314Packages.pyqt6
        tk # tkinter
        gcc
        _7zip-zstd
    ];

    services.udev.packages = with pkgs; [
        logitech-udev-rules
        solaar
    ];

    services.keyd = {
        enable = true;
        keyboards = {
            copilot = {
                ## the id of your keyboard taken from the monitor command - specifying it here and not using a wildcard * might avoid the aforementioned libinput issue with palm rejection.
                ids = [ "*" ];
                settings = {
                    main = {
                        "leftmeta+leftshift+f23" = "layer(control)";
                    };
                };
            };
        };
    };

}
