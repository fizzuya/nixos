{ config, pkgs, username, ... }:

let
    # gives btop a pointer to the gpu
    wrapped-btop = pkgs.symlinkJoin {
        name = "btop";
        paths = [ pkgs.btop ];
        buildInputs = [ pkgs.makeWrapper ];
        postBuild = ''
        wrapProgram $out/bin/btop \
            --prefix LD_LIBRARY_PATH : "/run/opengl-driver/lib:/run/opengl-driver-32/lib"
        '';
    };
in
{
    config = {
        environment.systemPackages = with pkgs;[
            wrapped-btop
        ];
    };
}
