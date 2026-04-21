{...}: {
  fileSystems."/home/iuricarras/Videos" = {
    device = "/dev/disk/by-label/VIDEOS";
    fsType = "ext4";
    options = ["nofail" "x-systemd.device-timeout=5"];
  };
}
