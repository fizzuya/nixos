{ config, pkgs, ... }:

{
    imports = [
        ./firefox
        ./chromium
    ];
}
