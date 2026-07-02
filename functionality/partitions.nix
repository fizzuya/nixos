{ config, pkgs, ... }:

{
  fileSystems."/home/fizzu/storage" = {
    device = "/run/media/fizzu/storage";
    fsType = "none";
    options = [
      "bind"
      "nofail"
      # wait until the source directory exists
      "x-systemd.requires=/run/media/fizzu/storage"
    ];
  };

  fileSystems."/home/fizzu/extra" = {
    device = "/run/media/fizzu/extra";
    fsType = "none";
    options = [
      "bind"
      "nofail"
      # wait until the source directory exists
      "x-systemd.requires=/run/media/fizzu/extra"
    ];
  };

  # ensures the target directory exists
  systemd.tmpfiles.rules = [
    "d /home/fizzu/storage 0755 fizzu users -"
    "d /home/fizzu/extra 0755 fizzu users -"
  ];
}
