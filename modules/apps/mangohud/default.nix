{ config, pkgs, ... }:

{
    environment.systemPackages = with pkgs; [
        mangohud
    ];

    # per user mangohud config:
    home-manager.users.fizzu = { ... }: {
        # tying MangoHud config path into the whole thing
        xdg.configFile = {
            "MangoHud/MangoHud.conf".source = ./MangoHud-configs/MangoHud.conf;
            "MangoHud/custom.conf".source = ./MangoHud-configs/custom.conf;
            "MangoHud/default.conf".source = ./MangoHud-configs/default.conf;
            "MangoHud/presets.conf".source = ./MangoHud-configs/presets.conf;
        };
    }; # user profile
}
