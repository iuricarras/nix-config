{...}:
{
  fileSystems."/home/iuricarras/Games/ESSD" = {
    device = "/dev/disk/by-label/ESSD";
    fsType = "ext4";
    options = ["nofail" "x-systemd.device-timeout=5"];
  };

  fileSystems."/home/iuricarras/Games/HDD" = {
    device = "/dev/disk/by-label/HDDLINUX";
    fsType = "ext4";
    options = ["nofail" "x-systemd.device-timeout=5"];
  };
}