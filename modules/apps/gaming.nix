{ config, pkgs, ... }:

let
    llauncher-endfield = import ./llauncher-endfield {inherit pkgs;};
in

{
    imports = [
        ./mangohud
        ./steam
    ];

    environment.systemPackages = with pkgs; [
        lutris
        xivlauncher
        (pkgs.prismlauncher.override {
            jdks = [openjdk25 temurin-bin-21 temurin-bin-17 temurin-bin-8];
        })
        min-ed-launcher
        deadlock-mod-manager
        llauncher-endfield
        gale

        protonplus
        protontricks
        vulkan-tools
        mesa-demos

        mangohud
        gamescope

        wineWow64Packages.stable
        winetricks
    ];

    environment.sessionVariables = {
#         PROTON_ENABLE_WAYLAND="1"; # if uncommented it fucks up up steam overlay on proton-GE and more

        PROTON_HIDE_NVIDIA_GPU="0";
        PROTON_NVIDIA_LIBS="1";

        PROTON_DISABLE_NVAPI="0";
        PROTON_ENABLE_NVAPI="1";
        PROTON_FORCE_NVAPI="1";
        DXVK_ENABLE_NVAPI="1";
        PROTON_DLSS_UPGRADE="1";
        PROTON_ENABLE_NGX_UPDATER="1";
        MANGOHUD="1";
        VKD3D_CONFIG = "dxr11,dxr";
    };
}
