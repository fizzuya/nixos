{ pkgs, ... }:

let
    fetchurl = pkgs.fetchurl;
    appimageTools = pkgs.appimageTools;

    version = "1.1.8";
    pname = "antra";

    src = fetchurl {
        url = "https://github.com/anandprtp/Antra/releases/download/v${version}/Antra-Linux.AppImage";
        hash = "sha256-g+x5ap/6nqdeVccdV1kz3kBg9y6fbplXIp+uBr75790=";
    };

    appimageContents = appimageTools.extract {inherit pname version src;};
in

appimageTools.wrapType2 {
    inherit pname version src;

    extraPkgs = pkgs: with pkgs; [
        libsoup_3
        webkitgtk_4_1
        glib-networking
        openssl
    ];

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

        # iunno just slop
#         wrapProgram $out/bin/${pname}-${version} \
#         --prefix GIO_EXTRA_MODULES : "${pkgs.glib-networking}/lib/gio/modules" \
#         --prefix XDG_DATA_DIRS : "${pkgs.gsettings-desktop-schemas}/share" \
#         --suffix XDG_DATA_DIRS : "${pkgs.gtk3}/share/gsettings-schemas/${pkgs.gtk3.name}"
      '';

    dieWithParent = false;
}







