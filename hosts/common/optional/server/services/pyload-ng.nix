{
  config,
  lib,
  pkgs,
  ...
}: {
  virtualisation.oci-containers = {
    containers = {
      pyload-ng = {
        image = "lscr.io/linuxserver/pyload-ng:latest";
        ports = ["8000:8000"];
        volumes = [
          "/var/docker/pyload-ng/config:/config"
          "/mnt/ext/media/downloads:/downloads"
        ];
        environment = {
          TZ = "Europe/Lisbon";
        };
      };
    };
  };
}
