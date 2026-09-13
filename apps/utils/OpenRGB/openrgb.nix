{ profile-name, ...}:
{ config, pkgs, username, ... }:

let
    source = "/etc/nixos/apps/utils/OpenRGB";
#     profile-name = "pink-cyan";
    profile-file = "${profile-name}.orp";
    config-path = "${config.users.users.${username}.home}/.config/OpenRGB";
in
{
    environment.systemPackages = with pkgs; [
        openrgb
    ];

    systemd.services.openrgb-bullshit = with pkgs;{
        after = [ "multi-user.target" "openrgb.service" ];
        wants = [ "openrgb.service" ];
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
            User = "root";
            # writeshellscript bc no innate support for multiline bullshit in ExecStart
            ExecStart = writeShellScript "openrgb-bullshit-script" ''
            # wait a tad just in case something takes a bit to load
            ${bash}/bin/bash -c '${coreutils}/bin/sleep 1

            # create folder and copy stuffs into it
            ${coreutils}/bin/mkdir -p "${config-path}"
            cp ${source}/${profile-file} ${config-path}/${profile-file}

            # set permissions to actual user we doing stuff for
            ${coreutils}/bin/chown -R ${username}:users "${config-path}"

            # doing the thing
                echo "profile: openrgb --profile ${profile-name}"
            ${openrgb}/bin/openrgb --config "${config-path}" --profile ${profile-name}'
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
