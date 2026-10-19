{ aliases, ... }:
{ config, pkgs, username, ... }:

{
    home-manager.users.${username} = { pkgs, ... }: {
        programs.kitty = {
            enable = true;
            shellIntegration.enableFishIntegration = true;
            settings = {
                shell = "fish";
            };
        };

        programs.fish = {
            enable = true;
            # autorun fastfetch
            shellInit = ''
                fastfetch
            '';

            shellAliases = aliases;
        };
    };
}
