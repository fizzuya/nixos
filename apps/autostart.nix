{config, pkgs, ...}:

{
    # make an autorun service that runs once and does whatever
    systemd.user.services.autorun = {
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

