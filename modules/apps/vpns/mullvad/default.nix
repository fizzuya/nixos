{ config, pkgs, username, ... }:

{
    environment.systemPackages = with pkgs; [
        mullvad-vpn # "application" part of mullvad, needed so kde sees it as an app for example.
                    # vpn would work without it with gui but it'd need to be run with a terminal
    ];

    #enabling mullvad via service bc just adding package doesnt work, also making it have a gui
    services.mullvad-vpn = {
        enable = true;
        gui.enable = true;
    };
}
