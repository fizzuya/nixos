{ config, pkgs, ... }:

{
    imports = [
        ./audio
        ./bluetooth
        ./graphics
        ./kernel
        ./partitions
    ];
}
