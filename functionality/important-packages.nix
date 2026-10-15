{ config, pkgs, ... }:

{
    environment.systemPackages = with pkgs; [
        gcc # The GNU Compiler Collection includes compiler front ends for C, C++, Objective-C, Fortran, OpenMP for C/C++/Fortran, and Ada, as well as libraries for these languages (libstdc++, libgomp,…).
        pkgsCross.mingw32.buildPackages.gcc # i needed these for something specific but don't remember what it was. maybe not needed. not gonna bother checking. maybe i was trying to make spore work?
        pkgsCross.mingwW64.buildPackages.gcc
        gnumake
        dotnetCorePackages.sdk_10_0-bin # to run vintagestory natively in lutris
        coreutils
    ];

    environment.sessionVariables = {
        DOTNET_ROOT = "${pkgs.dotnetCorePackages.runtime_10_0-bin}/share/dotnet"; # for vintagestory, dont forget to set custom in lutris game conf if running via wine
    };
}
