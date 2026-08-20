
{ pkgs, ... }:

let

  fetchurl = pkgs.fetchurl;
  appimageTools = pkgs.appimageTools;

  version = "1.1.8";
  pname = "antra";

  src = fetchurl {
    url = "https://github.com{version}/Antra-Linux.AppImage";
    hash = "sha256-vXNVDVtvfiQuXthP0NHPFdNvvMTkGpx0UP8oddIWbNk=";
  };

  appimageContents = pkgs.appimageTools.extract {inherit pname version src;};

in
    pkgs.appimageTools.wrapType2 {
      inherit pname version src;

      extraPkgs = pkgs: with pkgs; [
        webkit2gtk_4_1
        glib-networking
        openssl

        # override doesn't preserve splicing https://github.com/NixOS/nixpkgs/issues/132651
        (buildPackages.wrapGAppsHook.override {inherit (buildPackages) makeWrapper;})
      ];

      pkgs = pkgs;
      extraInstallCommands = ''
        install -m 444 -D ${appimageContents}/${pname}.desktop -t $out/share/applications
        substituteInPlace $out/share/applications/${pname}.desktop \
          --replace 'Exec=AppRun' 'Exec=${pname}'
        cp -r ${appimageContents}/usr/share/icons $out/share

        # unless linked, the binary is placed in $out/bin/cursor-someVersion
        # ln -s $out/bin/${pname}-${version} $out/bin/${pname}
      '';

      extraBwrapArgs = [
        "--bind-try /etc/nixos/ /etc/nixos/"
      ];

      # vscode likes to kill the parent so that the
      # gui application isn't attached to the terminal session
      dieWithParent = false;
    }
