{ config, pkgs, username, ... }:


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

    nix-config-location = "/home/${username}/nixos/";
    aliases = {
        reswitch = "sudo nixos-rebuild switch --flake ${nix-config-location}"; # switches instantly
        re-dry-run = "sudo nixos-rebuild dry-run --flake ${nix-config-location}"; # doesnt apply, just builds to test it out
        re-test = "sudo nixos-rebuild test --flake ${nix-config-location}"; # deriv will apply until a reboot
        re-next-boot = "sudo nixos-rebuild boot --flake ${nix-config-location}"; # deriv will apply on reboot

        update = "gitgo && nix flake update && sudo nixos-rebuild switch --flake ${nix-config-location}";

#         fladd = "gitgo && gitadd flake.lock";
        flcommit = "gitadd flake.lock && gitcommit -m 'updated flake'";
        gitgo   = "cd ${nix-config-location}";
        gitstatus  = "git status";
        gitadd     = "git add";
        gitcommit  = "git commit";
        doall = "gitadd -A && rebuild";
        gitdiff = "git diff";
        gitcheckout = "git checkout";
        gitpush = "git push";
        githist    = "git log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(auto)%d%C(reset)' --all";
        archive = "7z a /home/${username}/storage/backups/nix/\"nixos - $(date +%Y-%m-%d).7z\" ${nix-config-location}";
    };
in
{
    environment.systemPackages = with pkgs;[
        fastfetch
        wrapped-btop
    ];

    environment.shellAliases = aliases;

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
