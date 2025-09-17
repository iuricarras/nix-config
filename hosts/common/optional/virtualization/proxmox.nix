{
  inputs,
  lib,
  ...
}: {
  services.proxmox-ve = {
    enable = true;
    ipAddress = "192.168.185.1";
  };

  services.proxmox-ve.bridges = ["vmbr0"];

  networking.bridges.vmbr0.interfaces = ["vmnet8"];
  networking.interfaces.vmbr0.useDHCP = lib.mkDefault true;

  nixpkgs.overlays = [
    inputs.proxmox-nixos.overlays."x86_64-linux"
  ];
}
