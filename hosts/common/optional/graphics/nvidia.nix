{
  lib,
  pkgs,
  config,
  ...
}: {
  hardware = {
    nvidia = {
      open = true;
      modesetting.enable = lib.mkDefault true;
      powerManagement.enable = lib.mkDefault true;
      powerManagement.finegrained = true;

      prime =
        if config.hostSpec.isLaptop && config.hostSpec.isAmdNvidia
        then {
          amdgpuBusId = "PCI:0:6:0";
          nvidiaBusId = "PCI:1:0:0";

          offload = {
            enable = true;
            enableOffloadCmd = true;
          };
        }
        else if config.hostSpec.isLaptop && !config.hostSpec.isIntelNvidia
        then {
          intelBusId = "PCI:0:2:0";
          nvidiaBusId = "PCI:1:0:0";

          offload = {
            enable = true;
            enableOffloadCmd = true;
          };
        }
        else null;
    };
    graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = [
        pkgs.libGL
        pkgs.vulkan-loader
        pkgs.vulkan-validation-layers
      ];
    };
  };

  services.xserver.videoDrivers = ["nvidia"];
}
