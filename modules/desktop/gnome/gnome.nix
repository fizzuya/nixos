{ config, pkgs, lib, username, ... }:

{
    config = lib.mkIf (config.mySystem.desktop-type == "gnome") {
        environment.systemPackages = with pkgs; [
            gedit
        ];

        services = {
            displayManager.gdm.enable = true;
            desktopManager.gnome.enable = true;
        };
    };

}
