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
    inputs.proxmox-nixos.nixosModules.proxmox-ve
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
      "hosts/common/disks/home.nix"
      "hosts/common/disks/hdd.nix"
      #
      # ========== Non-Primary Users to Create ==========
      #

      #
      # ========== Optional Configs ==========
      #
      "hosts/common/optional/bootloader/grub.nix"
      "hosts/common/optional/desktopEnvironment"
      #"hosts/common/optional/virtualization/virtualbox.nix"
      "hosts/common/optional/virtualization/libvirt.nix"
      "hosts/common/optional/virtualization/vmware.nix"
      #"hosts/common/optional/virtualization/waydroid.nix"
      #"hosts/common/optional/virtualization/proxmox.nix"
      "hosts/common/optional/audio.nix"
      "hosts/common/optional/gaming.nix"
      "hosts/common/optional/plymouth.nix"
      "hosts/common/optional/swap.nix"
      "hosts/common/optional/masters.nix"

      #
      # ========== One Time Configs ==========
      #
      #"hosts/common/optional/virtualization/docker.nix"
    ])
  ];

  #
  # ========== Host Specification ==========
  #

  hostSpec = {
    hostName = "rufus";
    isDEGnome = true; # enable Gnome desktop environment and various definitions on the configuration
  };

  networking = {
    networkmanager.enable = true;
  };

  boot.initrd = {
    systemd.enable = true;
  };

  # Nvidia GPU
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

  # Conservation Mode - Lenovo
  systemd.tmpfiles.settings = {
    "ideapad-set-conservation-mode" = {
      "/sys/bus/platform/drivers/ideapad_acpi/VPC2004:00/conservation_mode" = {
        "f+" = {
          group = "root";
          user = "root";
          mode = "0644";
          argument = "1";
        };
      };
    };
  };

  specialisation.fullbattery.configuration = {
    systemd.tmpfiles.settings = {
      "ideapad-set-conservation-mode" = {
        "/sys/bus/platform/drivers/ideapad_acpi/VPC2004:00/conservation_mode" = {
          "f+" = {
            group = "root";
            user = "root";
            mode = "0644";
            argument = lib.mkForce "0";
          };
        };
      };
    };
  };

  # Undervolt - CPU
  services.undervolt.enable = true;
  services.undervolt.coreOffset = -130;

  # https://wiki.nixos.org/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "24.11";
}
