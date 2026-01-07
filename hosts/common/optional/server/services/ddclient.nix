{
  pkgs,
  lib,
  config,
  ...
}:{
  services.ddclient = {
    enable = true;
    protocol = "cloudflare";
    zone = "gaiaserver.pt";
    username = "iuri.carrasqueiro@gmail.com";
    passwordFile = "${config.sops.secrets."cloudflare-api".path}";
    domains = [
      "gaiaserver.pt"
      "apollo.gaiaserver.pt"
      "artemis.gaiaserver.pt"
      "dadapi.gaiaserver.pt"
      "dad.gaiaserver.pt"
      "dadws.gaiaserver.pt"
      "demeter.gaiaserver.pt"
      "hades.gaiaserver.pt"
      "hephaestus.gaiaserver.pt"
      "poseidon.gaiaserver.pt"
      "minecraft.gaiaserver.pt"
      "access.gaiaserver.pt"
    ];
  };
}