{ config, pkgs, ... }:

{
    imports = [
        ./firefox
        ./chromium
    ];
    config = {
        xdg.mime.defaultApplications = {
            "text/html" = "firefox.desktop";
            "x-scheme-handler/http" = "firefox.desktop";
            "x-scheme-handler/https" = "firefox.desktop";
            "default-web-browser" = "firefox.desktop";
        };
    };
}
