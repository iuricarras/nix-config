{ pkgs, lib, config, ... }:
let
  app = "dad-vue";
  appDomain = "dad.gaiaserver.pt";
  dataDir = "/var/www/${app}/dist";
in {

  services.phpfpm.pools.${app} = {
    user = app;
    settings = {
      "listen.owner" = config.services.nginx.user;
      "listen.group" = config.services.nginx.group;
      "listen.mode" = "0660";
      "catch_workers_output" = 1;
      "pm" = "dynamic";
      "pm.max_children" = 75;
      "pm.start_servers" = 10;
      "pm.min_spare_servers" = 5;
      "pm.max_spare_servers" = 20;
      "pm.max_requests" = 500;
    };
  };

  users.groups.${app}.members = [ "${app}" ];
  users.users.${app} = {
    isSystemUser = true;
    group = "${app}";
  };
  users.users.nginx.extraGroups = [ "${app}" ];


  services.nginx = {
    enable = true;
    virtualHosts = {
      ${appDomain} = {
        root = "${dataDir}";
        forceSSL = true;
        sslCertificate = "/var/www/certs/cert";
        sslCertificateKey = "/var/www/certs/key";
        
        extraConfig = ''
            index index.html;
        '';

        locations."/" = {
          extraConfig = ''
            # First attempt to serve request as file, then
            # as directory, then fall back to displaying a 404.
            try_files $uri $uri/ /index.html;
          '';
	      };
      };
    };
  };
}

