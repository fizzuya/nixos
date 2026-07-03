{ config, pkgs, ... }:

{
    environment.systemPackages = with pkgs;[
        fastfetch
        btop
    ];

#     programs.bash.shellAliases = {
#         rebuild = "sudo nixos-rebuild switch --flake /etc/nixos";
#         gitgo = "cd /etc/nixos";
#         status = "sudo git status /etc/nixos";
#         add = "sudo git add";
#         hist = "sudo git log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(auto)%d%C(reset)' --all";
#     };

    home-manager.users.fizzu = { pkgs, ... }: {
        programs.kitty = {
            enable = true;
            shellIntegration.enableFishIntegration = true;
            settings = {
                shell = "fish";
            };
        };
        # autorun fastfetch
        programs.fish = {
            enable = true;
            shellInit = ''
                fastfetch
            '';

            shellAliases = {
                rebuild = "sudo nixos-rebuild switch --flake /etc/nixos";
                gitgo   = "cd /etc/nixos";
                gitstatus  = "sudo git status";
                gitadd     = "sudo git add";
                gitcommit  = "sudo git commit";
                gitdoall = "gitgo && gitadd -A && rebuild";
                githist    = "sudo git log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(auto)%d%C(reset)' --all";
            };
        };
    };
}
