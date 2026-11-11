{ config, pkgs, username, ... }:

{
    environment.systemPackages = with pkgs; [
        lmstudio
    ];
}
