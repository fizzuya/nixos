{ config, pkgs, ... }:

{
    imports = [
        ./mullvad
        ./proton-vpn
    ];

    environment.systemPackages = with pkgs; [
        wireguard-tools
    ];
}
