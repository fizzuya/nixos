{ config, pkgs, modulesPath, ... }:

{
    environment.systemPackages = with pkgs; [
        solaar
        git
        home-manager
    ];
    services.udev.packages = with pkgs; [
    logitech-udev-rules
    solaar
    ];
}
