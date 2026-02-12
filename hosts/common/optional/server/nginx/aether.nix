{
  pkgs,
  lib,
  config,
  ...
}: let
  hostname = config.hostSpec.server.hostname;
in {
  services.nginx = {
    virtualHosts."aether.${hostname}" = {
      forceSSL = true;
      sslCertificate = "${config.sops.secrets."certs/pub".path}";
      sslCertificateKey = "${config.sops.secrets."certs/key".path}";
      locations."/" = {
        proxyPass = "http://127.0.0.1:8384";
        extraConfig = ''
          proxy_set_header X-Real-IP $remote_addr;
          proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
          proxy_set_header X-Forwarded-Proto $scheme;
          proxy_set_header X-Forwarded-Protocol $scheme;
          proxy_set_header X-Forwarded-Host $http_host;
        '';
      };
    };
  };
}
