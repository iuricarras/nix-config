{
  config,
  lib,
  pkgs,
  ...
}: {
  services.radarr = {
    enable = true;
    user = "streaming";
    group = "streaming";
  };

    users.users."streaming" = {
    isSystemUser = true;
    group = "streaming";
  };
}
