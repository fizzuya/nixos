{ config, pkgs, ... }:

{
    home-manager.useGlobalPkgs = true;
    home-manager.useUserPackages = true;

    home-manager.users.fizzu = { pkgs, ... }: {
        home.stateVersion = "26.11";

        imports = [

        ];

    };
}
