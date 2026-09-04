{ config, pkgs, ... }:

{
    # Enable the KDE Plasma Desktop Environment.
    services.displayManager.sddm.enable = true;
    services.desktopManager.plasma6.enable = true;
#     services.displayManager.sddm.wayland.enable = true;

    # Configure keymap in X11
    services.xserver.xkb = {
    # Enable the X11 windowing system.
    # You can disable this if you're only using the Wayland session.
    enable = true;
    layout = "us";
        variant = "";
  };

    krunner.enable = false;
    environment.systemPackages = with pkgs; [
        kdePackages.sddm-kcm # SDDM configuration module
        kdePackages.partitionmanager # Disk and partition management
    ];

    environment.plasma6.excludePackages = with pkgs; [
#         kdePackages.elisa # Music player
        kdePackages.krunner

#         kdePackages.kdepim-runtime # Akonadi agents
#         kdePackages.kmahjongg
#         kdePackages.kmines
#         kdePackages.konversation # IRC client
#         kdePackages.kpat # Solitaire
#         kdePackages.ksudoku
#         kdePackages.ktorrent
    ];
}
