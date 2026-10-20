{
  pkgs,
  lib,
  config,
  ...
}: let 
    hostname = config.hostSpec.server.hostname;
in {
  services.nginx = {
    virtualHosts."eleuthia.${hostname}" = {
      forceSSL = true;
      sslCertificate = "${config.sops.secrets."certs/pub".path}";
      sslCertificateKey = "${config.sops.secrets."certs/key".path}";
      locations."/" = {
        proxyPass = "http://127.0.0.1:8000";
        proxyWebsockets = true;
      };
    };
  };
}
