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
        steam
    ];
    programs.steam = {
#         package = custom-steam;
        extraCompatPackages = with pkgs; [  ];

        enable = true;
        remotePlay.openFirewall = true;
        dedicatedServer.openFirewall = true;
    };

    # make an autorun service that runs once and does whatever
    systemd.user.services.steam-autorun = {
        after = [ "graphical-session.target" ];
        wants = [ "graphical-session.target" ];
        wantedBy = [ "graphical-session.target" ];
        serviceConfig = {
            ExecStart = ''
            ${config.programs.steam.package}/bin/steam -silent -console
            '';
            Restart = "on-failure";
            RestartSec = 5;
#             Type = "oneshot";
        };
    };
}
