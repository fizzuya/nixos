
{ config, pkgs, ... }:

{
    xdg.portal = {
        enable = true; # plasma does it anyway. false would throw a conflict error
        extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
        config = {
        common = {
            default = "kde";
                "org.freedesktop.impl.portal.FileChooser" = [ "gtk" ];
            };
        };
    };
}
