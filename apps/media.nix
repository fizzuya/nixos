{ config, pkgs, inputs, ... }:

{
    # this is ASS
    # environment.sessionVariables = {
    #     PIPEWIRE_LATENCY = "48000";
    #     PIPEWIRE_QUANTUM = "1024/2048";
    # };
    environment.systemPackages = with pkgs; [
        spotify # spicetify has its own spotify i guess ?? buh
        spotube
        yt-dlp
        kdePackages.kolourpaint
        vlc
        qbittorrent
        (wrapOBS {
            plugins = with obs-studio-plugins;[
                obs-pipewire-audio-capture
            ];
        })
        discord
    ];

    home-manager.users.fizzu = {inputs, ...}:{
        imports = [inputs.spicetify-nix.homeManagerModules.default];

        programs.spicetify =
        let
        spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};
        in
        {
        enable = true;
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
