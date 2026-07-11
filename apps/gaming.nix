{ config, pkgs, ... }:

# let
#     # making steam work with params from custom nvidia-offload in nvidia.nix
#     # because for whatever reason without this block it just does not want to boot nms. amazing
#     custom-steam = pkgs.steam.override{
#         extraEnv = {
#             __NV_PRIME_RENDER_OFFLOAD = "1";
#             __NV_PRIME_RENDER_OFFLOAD_PROVIDER = "NVIDIA-G0";
#             __GLX_VENDOR_LIBRARY_NAME = "nvidia";
#             __VK_LAYER_NV_optimus = "NVIDIA_only";
#         };
#     };
# in
{
    environment.systemPackages = with pkgs; [
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
#         PROTON_ENABLE_WAYLAND="1";

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
#         package = custom-steam;

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
