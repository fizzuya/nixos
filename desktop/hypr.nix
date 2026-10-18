{ config, pkgs, lib, inputs, username, ... }:

{
    imports = [
        ./noctalia.nix # noctalia variable config.mySystem.noctalia-enable in flake
    ];

    config = lib.mkIf (config.mySystem.desktop-type == "hypr") {
        programs.hyprland.enable = true; # enable Hyprland system wide

        environment.systemPackages = [
            # ... other packages
            pkgs.kitty # required for the default Hyprland config
        ];


        home-manager.users.${username} = {inputs, ...}:{
            programs.kitty.enable = true; # required for the default Hyprland config
            wayland.windowManager.hyprland.enable = true; # enable Hyprland

            package = null; # https://wiki.hypr.land/Nix/Hyprland-on-Home-Manager/
            portalPackage = null;


            # Optional, hint Electron apps to use Wayland:
            home.sessionVariables.NIXOS_OZONE_WL = "1";

            xdg.configFile."hypr" = {
                source = ./hypr-bunny;
                recursive = true;
            };

        };
    };
}
