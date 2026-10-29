{ config, pkgs, ... }:




let
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

    fuck_two_buttons = {
        main = {
            "calc" = "delete";
            "scrollup" = "delete";
        };
    };

    lil_right_enter_fix = { # just so it works in deadlock and whatnot
        main = {
            "kpenter" = "enter";
        };
    };

in

{
    environment.systemPackages = with pkgs; [
        keyd
    ];

    services.keyd = {
        enable = true;
        keyboards = {
            default = {
                ids = [ "*" ]; # keyboard id, * for all # 0001:0001:6fb3735a
#                 settings = copilot;
#                 settings = pkgs.lib.recursiveUpdate copilot dead_row_bandaid; # merges the 2 into one file
                settings = pkgs.lib.recursiveUpdate(pkgs.lib.recursiveUpdate copilot lil_right_enter_fix) fuck_two_buttons; # dont do that. this is stupid. TODO: fix the bs. make like an array or sth idk
            };
        };
    };
}
