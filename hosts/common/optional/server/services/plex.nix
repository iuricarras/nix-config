{ config, lib, pkgs, ... }:
{
  services.plex = {
    enable = true;
    openFirewall = true;
    group="streaming";
  };
  
  users.groups.streaming.members = ["streaming"];
}