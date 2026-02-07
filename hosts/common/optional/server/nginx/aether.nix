{
  pkgs,
  lib,
  config,
  ...
}: {
  services.nginx = {
    virtualHosts."aether.gaiaserver.pt" = {
      forceSSL = true;
      sslCertificate = "/var/www/certs/cert";
      sslCertificateKey = "/var/www/certs/key";
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
