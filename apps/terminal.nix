{ config, pkgs, ... }:


let
    # gives btop a pointer to the gpu
    wrapped-btop = pkgs.symlinkJoin {
        name = "btop";
        paths = [ pkgs.btop ];
        buildInputs = [ pkgs.makeWrapper ];
        postBuild = ''
        wrapProgram $out/bin/btop \
            --prefix LD_LIBRARY_PATH : "/run/opengl-driver/lib:/run/opengl-driver-32/lib"
        '';
    };
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

        programs.fish = {
            enable = true;
            # autorun fastfetch
            shellInit = ''
                fastfetch
            '';

            shellAliases = {
                rebuild = "sudo nixos-rebuild switch --flake /etc/nixos";
                update = "gitgo && sudo nix flake update && rebuild";

#                 fladd = "gitgo && gitadd flake.lock";
                flcommit = "gitgo && gitadd flake.lock && gitcommit -m 'updated flake'";
                gitgo   = "cd /etc/nixos";
                gitstatus  = "sudo git status";
                gitadd     = "sudo git add";
                gitcommit  = "sudo git commit";
                doall = "gitadd -A && rebuild";
                gitdiff = "sudo git diff";
                gitcheckout = "sudo git checkout";
                gitpush = "sudo git push";
                githist    = "sudo git log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(auto)%d%C(reset)' --all";
                archive = "7z a /home/fizzu/storage/backups/nix/\"nixos - $(date +%Y-%m-%d).7z\" /etc/nixos";
            };
        };
    };
}
