{ config, pkgs, username, ... }:

{
    environment.systemPackages = with pkgs; [
        (ollama.override {
            acceleration = "cuda";
        })
    ];

    services.ollama = {
        enable = true;
        package = pkgs.ollama-cuda;
        # Optional: preload models, see https://ollama.com/library
#         loadModels = [ "qwen3.5:4b"];
    };
}
