{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    (lutris.override {
      lutris-unwrapped = lutris-unwrapped.overrideAttrs (oldAttrs: {
        postPatch = (oldAttrs.postPatch or "") + ''
          substituteInPlace lutris/util/display.py \
            --replace-fail 'if LIB_GNOME_DESKTOP_AVAILABLE:' 'if LIB_GNOME_DESKTOP_AVAILABLE and hasattr(GnomeDesktop, "RRScreen"):'
        '';
      });
    })
  ];
}
