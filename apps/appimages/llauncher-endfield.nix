{ pkgs, ... }:

let
  fetchurl = pkgs.fetchurl;
  appimageTools = pkgs.appimageTools;

  version = "1.3.4";
  pname = "llauncher-endfield";

  src = fetchurl {
    url = "https://github.com{version}/LLauncher_${version}_amd64.AppImage"; # Fixed URL interpolation syntax error
    hash = "sha256-sSeWmncHf+nYOtAgk2HjsfM8dwlrHo6QxHT9ttArve4=";
  };

  appimageContents = appimageTools.extract { inherit pname version src; };
in

appimageTools.wrapType2 {
  inherit pname version src;

  extraPkgs = pkgs: (appimageTools.defaultFhsEnvArgs.multiPkgs pkgs) ++ (with pkgs; [
    libsoup_3
    webkitgtk_4_1
    glib-networking
    gtk3
    openssl
    glib
    cairo
    gdk-pixbuf

    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good

    libGL
    vulkan-loader
    mesa-demos
    libgbm
    libdrm

    egl-wayland
    libdecor
    wayland
    dwproton-bin
  ]);


    extraInstallCommands = ''
        # installing the thing
        install -m 444 -D ${appimageContents}/*.desktop $out/share/applications/${pname}.desktop

#         substituteInPlace $out/share/applications/${pname}.desktop \
#           --replace-fail 'Exec=AppRun' 'Exec=${pname}'

        # substituteInPlace is bitching because it doesnt see the equivalent of Exec=AppRun inside antra.desktop so gotta normalize the thing inside and use this
        chmod +w $out/share/applications/${pname}.desktop
        sed -i 's|^Exec=.*|Exec=${pname}|g' $out/share/applications/${pname}.desktop

        # icons
        cp -r ${appimageContents}/usr/share/icons $out/share

        # unless linked, the binary is placed in $out/bin/pname-version
        # ln -s $out/bin/${pname}-${version} $out/bin/${pname}
      '';

    dieWithParent = false;
}


