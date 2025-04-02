{
  inputs,
  lib,
  ...
}:
let
in
{
  imports = [
    #
    # ========== Hardware ==========
    #
    ./hardware-configuration.nix
    inputs.hardware.nixosModules.common-cpu-amd
    #inputs.hardware.nixosModules.common-cpu-intel
    inputs.hardware.nixosModules.common-gpu-amd
    #inputs.hardware.nixosModules.common-gpu-nvidia
    #inputs.hardware.nixosModules.common-gpu-intel
    inputs.hardware.nixosModules.common-pc-ssd

    #
    # ========== Disk Layout ==========
    #
    #inputs.disko.nixosModules.disko

    #
    # ========== Misc Inputs ==========
    #

    (map lib.custom.relativeToRoot [
      #
      # ========== Required Configs ==========
      #
      "hosts/common/core"

      #
      # ========== Optional Configs ==========
      #
      "hosts/optional/bootloader/grub.nix"
      "hosts/optional/desktopEnvironment/gnome.nix"
      "hosts/optional/virtualization/virtualbox.nix"
      "hosts/optional/virtualization/libvirt.nix"
      "hosts/optional/virtualization/vmware.nix"
      "hosts/optional/audio.nix"
      "hosts/optional/gaming.nix"
      "hosts/optional/plymouth.nix"
      "hosts/optional/swap.nix"
    ])
  ];

  #
  # ========== Host Specification ==========
  #

  hostSpec = {
    hostName = "yoggi";
  };

  networking = {
    networkmanager.enable = true;
    enableIPv6 = false;
  };

  boot.initrd = {
    systemd.enable = true;
  };

  # https://wiki.nixos.org/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "24.11";
}