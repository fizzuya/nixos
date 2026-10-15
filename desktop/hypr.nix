{ config, pkgs, lib, username, ... }:

lib.mkIf (config.mySystem.desktop-type == "hypr") {
    programs.hyprland.enable = true; # enable Hyprland

    environment.systemPackages = [
        # ... other packages
        pkgs.kitty # required for the default Hyprland config
    ];


    home-manager.users.${username} = {inputs, ...}:{
        programs.kitty.enable = true; # required for the default Hyprland config
        wayland.windowManager.hyprland.enable = true; # enable Hyprland

        # Optional, hint Electron apps to use Wayland:
        home.sessionVariables.NIXOS_OZONE_WL = "1";
    };
}
