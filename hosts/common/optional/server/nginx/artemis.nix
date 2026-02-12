{
  pkgs,
  lib,
  config,
  ...
}: let
  hostname = config.hostSpec.server.hostname;
in{
  services.nginx = {
    virtualHosts."artemis.${hostname}" = {
      forceSSL = true;
      sslCertificate = "${config.sops.secrets."certs/pub".path}";
      sslCertificateKey = "${config.sops.secrets."certs/key".path}";
      locations."/" = {
        proxyPass = "http://127.0.0.1:5055";
        extraConfig = ''
          proxy_set_header Referer $http_referer;
          proxy_set_header Host $host;
          proxy_set_header X-Real-IP $remote_addr;
          proxy_set_header X-Real-Port $remote_port;
          proxy_set_header X-Forwarded-Host $host:$remote_port;
          proxy_set_header X-Forwarded-Server $host;
          proxy_set_header X-Forwarded-Port $remote_port;
          proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
          proxy_set_header X-Forwarded-Proto $scheme;
          proxy_set_header X-Forwarded-Ssl on;
        '';
      };
    };
  };
}
