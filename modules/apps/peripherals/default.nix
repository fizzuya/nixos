{ config, pkgs, username, ... }:

let
    openrgb-profile = "pink-cyan";
in
{
    # importing all the openrgb handling in the world in its own file in its own folder bc openrgb is a bitch and wants a whole ass script after the evil update
    imports = [
        (import ./OpenRGB/openrgb.nix { profile-name = "${openrgb-profile}"; })
        ./keyd
        ./logiops
    ];
}
