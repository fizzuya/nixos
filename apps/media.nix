{ config, pkgs, inputs, ... }:

let
    antra = import ./appimages/antra.nix {inherit pkgs;};
in
{
    environment.systemPackages = with pkgs; [
        spotify # spicetify has its own spotify i guess ?? buh
        spotube
        antra

        tauon # pretty good for what i want despite ui being a bit meh
        deadbeef # same as tauon bc gnomve otherwise pretty good
#         audacious # pretty good but for some godforsaken reason they decided to make volume slider embedded into a button what the actual fuck are they mentally challenged
#         rhythmbox # ass
#         amarok # eh + overcomplicated + stupid + chud + explode

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
