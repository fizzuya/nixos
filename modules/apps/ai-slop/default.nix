{ config, pkgs, username, ... }:

{
    imports = [
        ./ollama
        ./claude
        ./opencode
        ./lmstudio
    ];
}
