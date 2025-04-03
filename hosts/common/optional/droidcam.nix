{...}:
{
  boot.kernelModules = ["v4l2loopback"];

  networking.firewall.allowedTCPPorts = [4747];
  networking.firewall.allowedUDPPorts = [4747];
  
  programs.droidcam.enable = true;
}