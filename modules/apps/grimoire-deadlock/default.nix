{ config, lib, pkgs, inputs, ... }:

{
    config = {
        environment.systemPackages = [ inputs.grimoire.packages.${pkgs.stdenv.hostPlatform.system}.default ];
    };
}
