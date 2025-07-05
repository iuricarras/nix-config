{ config, lib, pkgs, ... }:
{
  services.xserver.videoDrivers = ["nvidia"];
  
  hardware.opengl = {
  	enable = true;
    driSupport32Bit = true;
  };
  
  hardware.nvidia = {
  	modesetting.enable = true;
  	powerManagement.enable = false;
  	powerManagement.finegrained = false;
  	open = false;
  	nvidiaSettings = true;
  	package = config.boot.kernelPackages.nvidiaPackages.stable;
  	prime = {
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
	  };
  }; 
}