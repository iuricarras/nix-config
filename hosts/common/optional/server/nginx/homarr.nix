{
  pkgs,
  lib,
  config,
  ...
}: {
  services.nginx = {
    virtualHosts."gaiaserver.pt" = {
      forceSSL = true;
      sslCertificate = "/var/www/certs/cert";
      sslCertificateKey = "/var/www/certs/key";
      locations."/" = {
        proxyPass = "http://127.0.0.1:7575";
        proxyWebsockets = true;
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
