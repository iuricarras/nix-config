{
  pkgs,
  lib,
  config,
  ...
}: {
  services.deluge = {
    enable = true;
    web.enable = true;
    user = "streaming";
    group = "streaming";
    declarative = true;
    config = {
      download_location = "/mnt/ext/media/downloads/torrents/";
      enabled_plugins = ["Label"];
    };
    authFile = pkgs.writeTextFile {
        name = "deluge-auth";
        text = ''
          localclient:deluge:10
        '';
    };
  }; 
  services.nginx = {
    virtualHosts."demeter.gaiaserver.pt" = {
      forceSSL = true;
      sslCertificate = "/var/www/certs/cert";
      sslCertificateKey = "/var/www/certs/key";
      locations."/" = {
        proxyPass = "http://127.0.0.1:8112";
        recommendedProxySettings = true;
      };
    };
  };
}
