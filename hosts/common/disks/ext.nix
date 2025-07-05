{...}: {
  fileSystems."/mnt/ext" = {
    device = "/dev/disk/by-label/Media";
    fsType = "ext4";
  };
}
