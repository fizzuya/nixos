{ config, pkgs, ... }:

{
    # trying to fix sound stuttering
    environment.sessionVariables = {
        PIPEWIRE_LATENCY = "128/48000";
        PIPEWIRE_QUANTUM = "128/1024";
    };
    environment.systemPackages = with pkgs; [
        spotify
        spotube
    ];

    home-manager.users.fizzu = {inputs, ...}:{
        imports = [inputs.spicetify-nix.homeManagerModules.default];

        programs.spicetify =
        let
        spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};
        in
        {
        enable = true;

        enabledExtensions = with spicePkgs.extensions; [
            adblock
            hidePodcasts
            shuffle # shuffle+ (special characters are sanitized out of extension names)
        ];
        enabledCustomApps = with spicePkgs.apps; [
            newReleases
#             ncsVisualizer
        ];
        enabledSnippets = with spicePkgs.snippets; [
#             rotatingCoverart
            pointer
        ];

        theme = spicePkgs.themes.catppuccin;
        colorScheme = "mocha";
        };
    };
}
