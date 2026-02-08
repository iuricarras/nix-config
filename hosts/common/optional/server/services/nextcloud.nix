{
  pkgs,
  lib,
  config,
  ...
}: {
  environment.etc."nextcloud-admin-pass".text = "DefaultPassword1234";
  services.nextcloud = {
    enable = true;
    package = pkgs.nextcloud32;
    hostName = "apollo.gaiaserver.pt";
    https = true;
    config.adminpassFile = "/etc/nextcloud-admin-pass";
    database.createLocally = true;
    config.dbtype = "mysql";
    configureRedis = true;
    maxUploadSize = "16G";
    settings.enabledPreviewProviders = [
      "OC\\Preview\\BMP"
      "OC\\Preview\\GIF"
      "OC\\Preview\\JPEG"
      "OC\\Preview\\Krita"
      "OC\\Preview\\MarkDown"
      "OC\\Preview\\MP3"
      "OC\\Preview\\OpenDocument"
      "OC\\Preview\\PNG"
      "OC\\Preview\\TXT"
      "OC\\Preview\\XBitmap"
      "OC\\Preview\\HEIC"
    ];
  };
  services.nginx.virtualHosts.${config.services.nextcloud.hostName} = {
    forceSSL = true;
    sslCertificate = "/var/www/certs/cert";
    sslCertificateKey = "/var/www/certs/key";
  };
}
