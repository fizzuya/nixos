{ config, pkgs, ... }:

{
    # configuring xdg to use gtk as default portal
    # thunar is gtk so it should be synced with firefox
    # dolphin is a BITCH so eeah gotta do gtk portal+thunar sadly
    xdg.portal = {
        enable = true; # plasma does it anyway. false would throw a conflict error
        extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
        config = {
        common = {
            "org.freedesktop.impl.portal.FileChooser" = [ "gtk" ];
        };
        };
    };

    # internal firefox shebang and if its even on
    programs.firefox = {
        enable = true;

        /* ---- POLICIES ---- */
        # Check about:policies#documentation for options.
        policies = {
            DisableTelemetry = true;
            DisableFirefoxStudies = true;
            EnableTrackingProtection = {
                Value = true;
                Locked = true;
                Cryptomining = true;
                Fingerprinting = true;
            };
            DisableFirefoxAccounts = true;
            DisableAccounts = true;
            DisableFirefoxScreenshots = true;
            OverrideFirstRunPage = "";
            OverridePostUpdatePage = "";
            DontCheckDefaultBrowser = true;
            DisplayBookmarksToolbar = "newtab"; # alternatives: "always" or "newtab"
            DisplayMenuBar = "default-off"; # alternatives: "always", "never" or "default-on"
            SearchBar = "unified"; # alternative: "separate"

            /* ---- EXTENSIONS ---- */
            # Check about:support for extension/add-on ID strings.
            # "force_installed" and "normal_installed".
            ExtensionSettings = let moz = short: "https://addons.mozilla.org/firefox/downloads/latest/${short}/latest.xpi"; in
                {
                # Valid strings for installation_mode are "allowed", "blocked", "force_installed" and "normal_installed".
                "*".installation_mode = "allowed";

                # uBlock Origin:
                "uBlock0@raymondhill.net" = {
                    install_url = moz "ublock-origin";
                    installation_mode = "force_installed"; # allowed for normal behavior or force_installed to well do that
                    private_browsing = true;
                };
                # Adnauseam
                # disable ublock if u use this bc it has ublock inside
                # tbh its kinda buns idk
                "adnauseam@rednoise.org" = {
                    install_url = moz "adnauseam";
                    installation_mode = "allowed"; #
                    private_browsing = true;
                };
                # Ghostery
                "firefox@ghostery.com" = {
                    install_url = moz "ghostery";
                    installation_mode = "force_installed";
                    private_browsing = true;
                };
                # ytRowFixer:
                "{b6b8a44a-b6d7-42e2-ba01-636632196d01}" = {
                    install_url = moz "youtube-row-fixer-extension";
                    installation_mode = "force_installed";
                    private_browsing = true;
                };
                # Ctrl+Number to switch tabs:
                "{84601290-bec9-494a-b11c-1baa897a9683}" = {
                    install_url = moz "ctrl-number-to-switch-tabs";
                    installation_mode = "force_installed";
                    private_browsing = true;
                };
                # Sponsorblock
                "sponsorBlocker@ajay.app" = {
                    install_url = moz "sponsorblock";
                    installation_mode = "force_installed";
                    private_browsing = true;
                };
                # Stylebot
                "{52bda3fd-dc48-4b3d-a7b9-58af57879f1e}" = {
                    install_url = moz "stylebot-web";
                    installation_mode = "force_installed";
                    private_browsing = true;
                };

            };
            /* ---- PREFERENCES ---- */
            # about:config for options
            Preferences = {
                "layout.spellcheckDefault" = 0;
                # previously opened tabs on boot
                "browser.startup.page" = 3;
                # middle mouse scroll stuff
                "general.autoScroll" = true;
                "middlemouse.paste" = false;
                # bookmark stuff. so the opened tab isnt forced into view.. i think. don't remember exactly
                "browser.tabs.loadInBackground" = true;
                "browser.tabs.loadBookmarksInBackground" = true;
                # so the browser saves the image logs in "network" debug screen if i need them after they're gone
                "browser.menu.showViewImageInfo" = true;

                # IF to use portal as filepicker
                    # 0 is never
                    # 1 is always
                    # 2 is auto
                "widget.use-xdg-desktop-portal.file-picker" = 2;
            };
            # home tab config
            "FirefoxHome" = {
                "SponsoredTopSites" = false;
    #             "Highlights": true | false;
    #             "Pocket": true | false,
    #             "Stories": true | false,
                "SponsoredPocket" = false;
                "SponsoredStories" = false;
            };

        };
    };
}

