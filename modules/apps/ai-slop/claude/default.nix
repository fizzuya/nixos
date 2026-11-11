{ config, pkgs, username, ... }:

{
    environment.systemPackages = with pkgs; [
        claude-code
        claude-monitor
    ];
}
