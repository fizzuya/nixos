{ config, pkgs, home-manager, ... }:

{
    environment.systemPackages = with pkgs; [
        steam
        lutris
        xivlauncher
        (pkgs.prismlauncher.override {
            jdks = [openjdk25 temurin-bin-21 temurin-bin-17 temurin-bin-8];
        })

        protonplus

        mangohud
        vulkan-tools

        wineWow64Packages.stable
        winetricks ];

    programs.steam = {
        enable = true;
    };

        # user config:
        home-manager.users.fizzu = {
            home.stateVersion = "26.11";

            xdg.configFile = {
                "MangoHud/MangoHud.conf".source = ./MangoHud-configs/MangoHud.conf;
                "MangoHud/custom.conf".source = ./MangoHud-configs/custom.conf;
                "MangoHud/default.conf".source = ./MangoHud-configs/default.conf;
                "MangoHud/presets.conf".source = ./MangoHud-configs/presets.conf;
            };
        }; # user profile

    # Required for modern gaming performance (Vulkan, MangoHud, etc.)
    hardware.graphics = {
        enable = true;
        enable32Bit = true;};
}
