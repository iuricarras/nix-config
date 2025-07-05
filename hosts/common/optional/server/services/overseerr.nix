{ config, lib, pkgs, ... }:
{
  virtualisation.oci-containers = {
  backend = "docker";
  containers = {
    overseerr = {
      image = "sctx/overseerr:latest";
      ports = ["5055:5055"];
      volumes = ["/var/docker/overseerr/config:/app/config"];
      environment = {
        LOG_LEVEL="debug";
        TZ="Europe/Lisbon";
      };
    };
  };
};

}