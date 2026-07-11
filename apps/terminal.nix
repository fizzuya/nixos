{ config, pkgs, ... }:


let
    # gives btop a pointer to the gpu
    wrapped-btop = pkgs.writeShellScriptBin "btop" ''
        export LD_LIBRARY_PATH="/run/opengl-driver/lib:$LD_LIBRARY_PATH"
        exec ${pkgs.btop}/bin/btop "$@"
    '';
in
{
    environment.systemPackages = with pkgs;[
        fastfetch
        wrapped-btop
    ];



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
                doall = "gitgo && gitadd -A && rebuild";
                gitdiff = "sudo git diff";
                gitcheckout = "sudo git checkout";
                githist    = "sudo git log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(auto)%d%C(reset)' --all";
            };
        };
    };
}
