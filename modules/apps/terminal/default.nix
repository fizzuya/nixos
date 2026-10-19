{ config, pkgs, username, ... }:

let
    nix-config-location = "/home/${username}/nixos/";
    aliases = {
        reswitch = "sudo nixos-rebuild switch --flake ${nix-config-location}"; # switches instantly
        re-dry-run = "sudo nixos-rebuild dry-run --flake ${nix-config-location}"; # doesnt apply, just builds to test it out
        re-test = "sudo nixos-rebuild test --flake ${nix-config-location}"; # deriv will apply until a reboot
        re-next-boot = "sudo nixos-rebuild boot --flake ${nix-config-location}"; # deriv will apply on reboot

        update = "gitgo && sudo nix flake update && sudo nixos-rebuild switch --flake ${nix-config-location}";

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
    imports = [
        (import ./kitty { inherit aliases; })
        ./btop
    ];

    config = {
        environment.systemPackages = with pkgs;[
            fastfetch
        ];
        environment.shellAliases = aliases;
    };
}
