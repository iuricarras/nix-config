{
  pkgs,
  lib,
  config,
  ...
}: {
  services.nginx = {
    virtualHosts."dadws.gaiaserver.pt" = {
      forceSSL = true;
      sslCertificate = "/var/www/certs/cert";
      sslCertificateKey = "/var/www/certs/key";
      locations."/" = {
        proxyPass = "http://127.0.0.1:8081";
        recommendedProxySettings = true;
        proxyWebsockets = true;
      };
    };
  };

  systemd.services.dadwebsocket = {
    wantedBy = ["multi-user.target"];
    after = ["nginx.service"];
    description = "Dad WebSocket";
    serviceConfig = {
      User = "nginx";
      Group = "nginx";
      Restart = "always";
      ExecStart = "${pkgs.bun}/bin/bun /var/www/dad-websocket/index.js";
      StartLimitBurst = "30";
      RestartSec = "5s";
    };
  };
}
