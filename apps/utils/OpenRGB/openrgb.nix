{ profile-name, ...}:
{ config, pkgs, username, ... }:

let
    source = "/etc/nixos/apps/utils/OpenRGB/";
#     profile-name = "cyan";
    profile-file = "${profile-name}.orp";
    config-path = "${config.users.users.${username}.home}/.config/OpenRGB/";
    json-path-idk = "/var/lib/OpenRGB/";

    # apparently /var/lib/OpenRGB/profiles/ is related
in
{
    environment.systemPackages = with pkgs; [
        openrgb
    ];

    systemd.services.openrgb-bullshit = with pkgs;{
        after = [ "multi-user.target" "openrgb.service" "suspend.target" ];
        wantedBy = [ "multi-user.target" "suspend.target" ];
        wants = [ "openrgb.service" ];
        serviceConfig = {
            User = "root";
            # writeshellscript bc no innate support for multiline bullshit in ExecStart
            ExecStart = writeShellScript "openrgb-bullshit-script" ''
            # wait a tad just in case something takes a bit to load
            ${bash}/bin/bash -c '${coreutils}/bin/sleep 1

            # create folder and copy stuffs into it
            ${coreutils}/bin/mkdir -p "${json-path-idk}/profiles"
            cp ${source}/*.json ${json-path-idk}/profiles

            # restarting openrgb bc its a giga bitch
            ${systemd}/bin/systemctl restart openrgb

            # doing the thing
                echo "profile: openrgb --profile ${profile-name}"
            ${openrgb}/bin/openrgb --config "${json-path-idk}" --profile ${profile-name}'
            '';
            Type = "oneshot";
        };
    };

    # necessary for udev rules,,,, i think
    services.hardware.openrgb = with pkgs;{
        package = pkgs.openrgb-with-all-plugins;
        enable = true;
#         startupProfile = "/etc/nixos/apps/OpenRGB/pink-cyan.orp"; # they KILLED it.
    };
}
