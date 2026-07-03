{config, pkgs, ...}:

# let autostartPrograms = with pkgs; [
#     steam
#     ];
# in
{
    # make an autorun service that runs once and does whatever
    systemd.user.services.autorun = {
        after = [ "graphical-session.target" ];
        wants = [ "graphical-session.target" ];
        wantedBy = [ "graphical-session.target" ];
        serviceConfig = {
            ExecStart = "${pkgs.steam}/bin/steam -silent";
            Restart = "on-failure";
            RestartSec = 5;
#             Type = "oneshot";
        };
    };
}

