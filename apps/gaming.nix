{ config, pkgs, ... }:

{
    environment.systemPackages = with pkgs; [
        steam
        lutris
        xivlauncher
        (pkgs.prismlauncher.override {
            jdks = [openjdk25 temurin-bin-21 temurin-bin-17 temurin-bin-8];
        })
        min-ed-launcher

        protonplus
        vulkan-tools
        mesa-demos

        mangohud
        gamescope

        wineWow64Packages.stable
        winetricks ];

    environment.sessionVariables = {
        PROTON_ENABLE_WAYLAND="1";

        PROTON_HIDE_NVIDIA_GPU="0";
        PROTON_NVIDIA_LIBS="1";

        PROTON_DISABLE_NVAPI="0";
        PROTON_ENABLE_NVAPI="1";
        PROTON_FORCE_NVAPI = "1";
        DXVK_ENABLE_NVAPI = "1";
        PROTON_DLSS_UPGRADE="1";

        PROTON_ENABLE_NGX_UPDATER="1";
        MANGOHUD="1";
    };

    programs.steam = {
        enable = true;
        remotePlay.openFirewall = true;
        dedicatedServer.openFirewall = true;
    };

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
