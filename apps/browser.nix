{ config, pkgs, ... }:
{
  environment.systemPackages = [
    pkgs.chromium
  ];

  xdg.mime.defaultApplications = {
    "text/html" = "firefox.desktop";
    "x-scheme-handler/http" = "firefox.desktop";
    "x-scheme-handler/https" = "firefox.desktop";
  };


  # Install firefox.
  programs.firefox = {
    enable = true;

    /* ---- POLICIES ---- */
      # Check about:policies#documentation for options.
    policies = {
        DisableTelemetry = true;
        DisableFirefoxStudies = true;
        EnableTrackingProtection = {
            Value= true;
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
        ExtensionSettings = {
            # Valid strings for installation_mode are "allowed", "blocked", "force_installed" and "normal_installed".
            "*".installation_mode = "allowed";

            # uBlock Origin:
            "uBlock0@raymondhill.net" = {
                install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
                installation_mode = "force_installed";
            };
            # ytRowFixer:
            "{b6b8a44a-b6d7-42e2-ba01-636632196d01}" = {
                install_url = "https://addons.mozilla.org/firefox/downloads/latest/youtube-row-fixer-extension/latest.xpi";
                installation_mode = "force_installed";
            };
            # Ctrl+Number to switch tabs:
            "{84601290-bec9-494a-b11c-1baa897a9683}" = {
                install_url = "https://addons.mozilla.org/firefox/downloads/latest/ctrl-number-to-switch-tabs/latest.xpi";
                installation_mode = "force_installed";
            };
            # Sponsorblock
            "sponsorBlocker@ajay.app" = {
                install_url = "https://addons.mozilla.org/firefox/downloads/latest/sponsorblock/latest.xpi";
                installation_mode = "force_installed";
            };
            # Stylebot
            "{52bda3fd-dc48-4b3d-a7b9-58af57879f1e}" = {
                install_url = "https://addons.mozilla.org/firefox/downloads/latest/stylebot-web/latest.xpi";
                installation_mode = "force_installed";
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
            # IF to use portal as filepicker
                # 0 is never
                # 1 is always
                # 2 is auto
            "widget.use-xdg-desktop-portal.file-picker" = 1;
        };
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

