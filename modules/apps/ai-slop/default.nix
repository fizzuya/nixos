{ config, pkgs, username, ... }:

{
    imports = [
        ./ollama
        ./claude
    ];
}
