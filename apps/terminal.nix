{ config, pkgs, modulesPath, ... }:

{
    environment.systemPackages = [
        pkgs.kitty
        pkgs.fastfetch
    ];
#     programs.kitty = {
#         enable = true;
#     };
}
