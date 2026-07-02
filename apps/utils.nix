{ config, pkgs, modulesPath, ... }:

{
    environment.systemPackages = with pkgs; [
        solaar
        git
    ];
}
