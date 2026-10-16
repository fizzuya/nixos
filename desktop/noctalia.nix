{ config, pkgs, lib, inputs, username, ... }:

{
    imports = [
        inputs.noctalia.nixosModules.default
    ];

    config = lib.mkIf ((config.mySystem.desktop-type == "hypr") && (config.mySystem.noctalia-enable == true)) {
        programs.noctalia = {
            enable = true;

            # Enables NetworkManager, Bluetooth, UPower, and a power profile service.
            recommendedServices.enable = true;
        };
        programs.noctalia.systemd.enable = true;


        home-manager.users.${username} = {
            imports = [
                inputs.noctalia.homeModules.default
            ];

            programs.noctalia = {
                enable = true;

                settings = { # This may also be a string or path to a .toml file.
                    theme = {
                    mode = "dark";
                    source = "builtin";
                    builtin = "Catppuccin";
                    };

                    wallpaper = {
                    enabled = true;
                    default.path = "/home/fizzu/storage/Slop/Important_stuff/chaos\ invoked\ -\ ismail\ inceoglu.jpg";
                    };
                };
            };
        };
    };
}
# https://docs.noctalia.dev/noctalia/getting-started/nixos/?section=tab-panel-5-1#tab-panel-5-1
