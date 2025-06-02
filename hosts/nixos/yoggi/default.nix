{
  inputs,
  lib,
  pkgs,
  ...
}:
let
in
{
  imports = lib.flatten [
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

    inputs.nurpkgs.modules.nixos.default
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
      #
      #
      "hosts/common/disks/hdd.nix"
      "hosts/common/disks/home.nix"

      #
      # ========== Optional Configs ==========
      #
      "hosts/common/optional/bootloader/grub.nix"
      "hosts/common/optional/desktopEnvironment"
      "hosts/common/optional/graphics/amd.nix"
      "hosts/common/optional/virtualization/virtualbox.nix"
      "hosts/common/optional/virtualization/libvirt.nix"
      "hosts/common/optional/virtualization/vmware.nix"
      "hosts/common/optional/audio.nix"
      "hosts/common/optional/gaming.nix"
      "hosts/common/optional/plymouth.nix"
      "hosts/common/optional/swap.nix"
      "hosts/common/optional/droidcam.nix"
    ])
  ];

  #
  # ========== Host Specification ==========
  #

  hostSpec = {
    hostName = "yoggi";
    isDEGnome = true; # enable GNOME desktop environment and various definitions on the system
  };

  networking = {
    networkmanager.enable = true;
    enableIPv6 = false;
  };

  boot.initrd = {
    systemd.enable = true;
  };

  boot.kernelPackages = pkgs.linuxPackages_zen;


  # https://wiki.nixos.org/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "24.11";
}