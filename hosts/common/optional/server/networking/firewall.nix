{ config, lib, pkgs, ... }:
{
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 80 443 8080 8443 25566 27017 5000];
    allowedUDPPorts = [ 2302 2303 2304 2306 ];
  };
}
