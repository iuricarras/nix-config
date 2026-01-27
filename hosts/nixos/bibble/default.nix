{
  inputs,
  lib,
  pkgs,
  ...
}: let
in {
  imports = lib.flatten [
    #
    # ========== Hardware ==========
    #
    ./hardware-configuration.nix
    inputs.hardware.nixosModules.common-cpu-intel
    inputs.hardware.nixosModules.common-gpu-nvidia
    inputs.hardware.nixosModules.common-pc-laptop
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
      # ========== Non-Primary Users to Create ==========
      #

      #
      # ========== Optional Configs ==========
      #
      "hosts/common/optional/bootloader/grub.nix"
      "hosts/common/optional/desktopEnvironment"
      "hosts/common/optional/audio.nix"
      "hosts/common/optional/plymouth.nix"
      "hosts/common/optional/swap.nix"

      #
      # ========== One Time Configs ==========
      #

    ])
  ];

  #
  # ========== Host Specification ==========
  #

  hostSpec = {
    hostName = "bibble";
    username = lib.mkForce "meri";
    #isDEPlasma = true; # enable Plasma desktop environment and various definitions on the configuration
  };

  networking = {
    networkmanager.enable = true;
  };

  boot.initrd = {
    systemd.enable = true;
  };

  # Nvidia GPU - Editar isto
  hardware = {
    nvidia = {
      open = true;
      modesetting.enable = lib.mkDefault true;
      powerManagement.enable = lib.mkDefault true;
      powerManagement.finegrained = true;

      prime = {
        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";
      };
    };
    graphics = {
      enable = true;
      extraPackages = [
        pkgs.libGL
      ];
    };
  };

  # https://wiki.nixos.org/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "25.11";
}
