{ config, pkgs, username, ... }:

{
    environment.systemPackages = with pkgs; [
        opencode
        opencode-desktop
    ];

}
