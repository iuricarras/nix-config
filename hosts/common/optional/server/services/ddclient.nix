{
  pkgs,
  lib,
  config,
  ...
}: let
  hostname = config.hostSpec.server.hostname;
in {
  services.ddclient = {
    enable = true;
    protocol = "cloudflare";
    zone = hostname;
    username = "iuri.carrasqueiro@gmail.com";
    passwordFile = "${config.sops.secrets."cloudflare-api".path}";
    domains = [
      "${hostname}"
      "apollo.${hostname}"
      "artemis.${hostname}"
      "dadapi.${hostname}"
      "dad.${hostname}"
      "dadws.${hostname}"
      "demeter.${hostname}"
      "hades.${hostname}"
      "hephaestus.${hostname}"
      "poseidon.${hostname}"
      "minecraft.${hostname}"
      "access.${hostname}"
      "aether.${hostname}"
    ];
  };
}
