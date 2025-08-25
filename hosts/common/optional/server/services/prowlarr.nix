{
  config,
  lib,
  pkgs,
  ...
}: {
  services.prowlarr = {
    enable = true;
    openFirewall = true;
  };
}
