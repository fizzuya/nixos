{ config, pkgs, modulesPath, ... }:

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

    # mangohud bullshit
#     xdg.configfile ={
#         "MangoHud/MangoHud.conf".source = "/etc/nixos/apps/MangoHud-configs/MangoHud.conf";
#         "MangoHud/custom.conf".source = "/etc/nixos/apps/MangoHud-configs/custom.conf";
#         "MangoHud/default.conf".source = "/etc/nixos/apps/MangoHud-configs/default.conf";
#         "MangoHud/presets.conf".source = "/etc/nixos/apps/MangoHud-configs/presets.conf";
#     };


    # Required for modern gaming performance (Vulkan, MangoHud, etc.)
    hardware.graphics =
    {
        enable = true;
        enable32Bit = true;};
}
