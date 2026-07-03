{ config, pkgs, ... }:

{
    environment.systemPackages = with pkgs; [
        solaar
        git
        home-manager
        keyd
    ];
    services.udev.packages = with pkgs; [
    logitech-udev-rules
    solaar
    ];
}
