{ config, pkgs, inputs, ... }:

{
    # this is ASS
    # environment.sessionVariables = {
    #     PIPEWIRE_LATENCY = "128/48000";
    #     PIPEWIRE_QUANTUM = "128/1024";
    # };
    environment.systemPackages = with pkgs; [
        spotify # spicetify has its own spotify i guess ?? buh
        spotube
        kdePackages.kolourpaint
    ];

    home-manager.users.fizzu = {inputs, ...}:{
        imports = [inputs.spicetify-nix.homeManagerModules.default];

        programs.spicetify =
        let
        spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};
        in
        {
        enable = false;
        spotifyPackage = pkgs.spotify; # making it use same spotify as system

        theme = spicePkgs.themes.catppuccin;
        colorScheme = "mocha";
        enabledExtensions = with spicePkgs.extensions; [
            adblock
            hidePodcasts
            shuffle # shuffle+ (special characters are sanitized out of extension names)
                    # causes ui to break sometimes apparently
        ];
        enabledCustomApps = with spicePkgs.apps; [
            newReleases
#             ncsVisualizer
        ];
        enabledSnippets = with spicePkgs.snippets; [
#             rotatingCoverart
#             pointer
        ];
        };
    };
}
