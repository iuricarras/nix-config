{
  inputs,
  lib,
  ...
}: {
  nix.settings.substituters = [
    "https://cache.saumon.network/proxmox-nixos"
  ];
  nix.settings.trusted-public-keys = ["cache.saumon.network/proxmox-nixos:D9RYSWpQQC/msZUWphOY2I5RLH5Dd6yQcaHIuug7dWM="];
  services.proxmox-ve = {
    enable = true;
    ipAddress = "192.168.214.1";
  };

  services.proxmox-ve.bridges = ["vmbr0"];

  networking.bridges.vmbr0.interfaces = ["vmnet8"];
  networking.interfaces.vmbr0.useDHCP = lib.mkDefault true;

  nixpkgs.overlays = [
    inputs.proxmox-nixos.overlays.x86_64-linux
  ];
}
