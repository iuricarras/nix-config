{pkgs, ...}: {
  hardware.graphics = {
    enable = true;
    extraPackages = [
      pkgs.libGL
    ];
    enable32Bit = true;
  };
  environment.variables.AMD_VULKAN_ICD = "RADV";
}
