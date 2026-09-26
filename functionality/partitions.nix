{ config, pkgs, ... }:

  # don't forget to fix IDs in hardware-configuration.nix after reinstall. or could run nixos-generate-config but i dont like that tbh id rather do it manually

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
    device = "/dev/disk/by-uuid/fac02089-a912-4bfa-8671-28ba3ac4a28d";
    fsType = "btrfs";
    options = [
      "users"
      "nofail"
      # wait until the source directory exists
      "x-systemd.requires=/dev/disk/by-uuid/fac02089-a912-4bfa-8671-28ba3ac4a28d"
    ];
  };
  swapDevices = [
      {device = "/swapfile" ; size = 1024 * 1; } # just do a minimum of 1 gb or it kinda shits itself bleegh
      {device = "/home/fizzu/extra/swapfile" ; # the "extra" partition
          size = 1024 * 16;}
  ];


  # ensures the target directory exists
  systemd.tmpfiles.rules = [
    "d /home/fizzu/storage 0755 fizzu users -"
    "d /home/fizzu/extra 0755 fizzu users -"
  ];

#   how to get uuids example:
# lsblk -o NAME,FSTYPE,UUID,MOUNTPOINTS
# NAME        FSTYPE UUID                                 MOUNTPOINTS
# sda         vfat   CF0C-3CDD                            /run/media/fizzu/120Gb-usb
# nvme0n1
# ├─nvme0n1p1 vfat   A800-F871                            /boot
# ├─nvme0n1p2 btrfs  14fef10b-a1c3-44b9-8bb3-39ecd22d3d6f /home/fizzu/extra
# ├─nvme0n1p3 ext4   283102ce-5d54-4133-a543-acf0c20da706 /nix/store
# │                                                       /
# └─nvme0n1p4 btrfs  63108475-f3e5-4e0f-bd85-19a546b82166 /home/fizzu/storage
}
