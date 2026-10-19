{pkgs, ...}: {
  boot.kernelPackages = pkgs.linuxPackages_zen;

  boot.kernelModules = ["ntsync"];
}
