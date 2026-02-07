{ pkgs, lib, config, ... }:
{
  services.cockpit = {
    enable = true;
    openFirewall = true;
    settings = {
      WebService = {
        Origins = lib.mkForce ''https://hades.gaiaserver.pt wss://hades.gaiaserver.pt'';
        ProtocolHeader = "X-Forwarded-Proto";
      };
    };
    plugins = [
      pkgs.cockpit-files
    ];
  };
  services.nginx = {
    virtualHosts."hades.gaiaserver.pt" =  {
      forceSSL = true;
      sslCertificate = "/var/www/certs/cert";
      sslCertificateKey = "/var/www/certs/key";
      locations."/" = {
        proxyPass = "https://127.0.0.1:9090";
        proxyWebsockets = true;
        recommendedProxySettings = true;
        extraConfig = ''
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_set_header X-Forwarded-Protocol $scheme;
        proxy_set_header X-Forwarded-Host $http_host;

        # Required for web sockets to function
        proxy_buffering off;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";

        # Pass ETag header from Cockpit to clients.
        # See: https://github.com/cockpit-project/cockpit/issues/5239
        gzip off;
        '';
      };
    };
  };
}