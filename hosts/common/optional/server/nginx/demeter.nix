{
  pkgs,
  lib,
  config,
  ...
}: let 
    hostname = config.hostSpec.server.hostname;
  in{
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
    virtualHosts."demeter.${hostname}" = {
      forceSSL = true;
      sslCertificate = "${config.sops.secrets."certs/pub".path}";
      sslCertificateKey = "${config.sops.secrets."certs/key".path}";
      locations."/" = {
        proxyPass = "http://127.0.0.1:8112";
        recommendedProxySettings = true;
      };
    };
  };
}
