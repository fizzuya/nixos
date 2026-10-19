{ config, pkgs, ... }:

{
    environment.systemPackages = with pkgs; [
        keyd
    ];

    services.keyd = {
        enable = true;
        keyboards = {
            default = {
                ids = [ " 0001:0001:6fb3735a " ]; # keyboard id, * for all
                settings = let
                    # NUKING the FUCK out of STUPID copilot key
                    copilot = {
                            main = {
                                "leftmeta+leftshift+f23" = "layer(control)";
                            };
                    };

                    dead_row_bandaid = {
                            main = {
                                "delete" = "backspace";
                                "calc" = "delete";
                                "insert" = "numlock";
                                "kpenter" = "enter";
                            };
                    };
                in pkgs.lib.recursiveUpdate copilot dead_row_bandaid; # merges the 2 into one file

            };
        };
    };
}
