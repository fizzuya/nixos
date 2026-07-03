{ config, pkgs, ... }:

{
  fileSystems."/home/fizzu/storage" = {
    device = "/dev/disk/by-uuid/63108475-f3e5-4e0f-bd85-19a546b82166";
    fsType = "btrfs";
    options = [
      "users"
      "nofail"
      # wait until the source directory exists
      "x-systemd.requires=/dev/disk/by-uuid/63108475-f3e5-4e0f-bd85-19a546b82166"
    ];
  };

  fileSystems."/home/fizzu/extra" = {
    device = "/dev/disk/by-uuid/14fef10b-a1c3-44b9-8bb3-39ecd22d3d6f";
    fsType = "btrfs";
    options = [
      "users"
      "nofail"
      # wait until the source directory exists
      "x-systemd.requires=/dev/disk/by-uuid/14fef10b-a1c3-44b9-8bb3-39ecd22d3d6f"
    ];
  };

  # ensures the target directory exists
  systemd.tmpfiles.rules = [
    "d /home/fizzu/storage 0755 fizzu users -"
    "d /home/fizzu/extra 0755 fizzu users -"
  ];
}
