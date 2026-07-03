{ config, pkgs, ... }:

{
    programs.steam.enable = true;

    home-manager.users.fizzu = { ... }: {
        xdg.configFile = {
            "autostart/steam.desktop".text = ''
            [Desktop Entry]
            Type=Application
            Name=Steam
            Exec=${pkgs.steam}/bin/steam -silent
            Icon=steam
            Terminal=true
            Categories=Game;
            '';
            "autostart/solaar.desktop".text = ''
            [Desktop Entry]
            Type=Application
            Name=Solaar
            Exec=${pkgs.solaar}/bin/solaar --w hide
            Icon=Solaar
            '';
        };
    };
}
