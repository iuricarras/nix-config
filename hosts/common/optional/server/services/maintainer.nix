{
  config,
  lib,
  pkgs,
  ...
}: {
  virtualisation.oci-containers = {
    containers = {
      maintainer = {
        image = "ghcr.io/maintainerr/maintainerr:latest";
        user = "990:988";
        ports = ["6246:6246"];
        volumes = ["/var/docker/maintainer/opt/data:/opt/data"];
        environment = {
          TZ = "Europe/Lisbon";
        };
      };
    };
  };
}