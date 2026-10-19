{
  pkgs,
  config,
  ...
}: let
  app = "catd";
  appDomainApi = "api.catd.eu";
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

  users.groups.${app}.members = ["${app}"];
  users.users.${app} = {
    isSystemUser = true;
    group = "${app}";
  };
  users.users.nginx.extraGroups = ["${app}"];

  services.nginx = {
    enable = true;
    virtualHosts = {
      ${appDomainApi} = {
        forceSSL = true;
        sslCertificate = "/var/www/certs_iot/cert.pem";
        sslCertificateKey = "/var/www/certs_iot/key.pem";

        locations."/" = {
          proxyPass = "https://127.0.0.1:5001";
          recommendedProxySettings = true;
          proxyWebsockets = true;
        };
      };
    };
  };

  systemd.services.catd = let
    python = pkgs.python313.withPackages (ppkgs:
      with ppkgs; [
        flask
        flask-cors
        firebase-admin
        python-dotenv
      ]);
  in {
    wantedBy = ["multi-user.target"];
    after = ["network.target"];
    description = "CatD";
    serviceConfig = {
      User = "catd";
      Group = "catd";
      Restart = "always";
      WorkingDirectory = "/var/www/catd";
      ExecStart = "${python}/bin/python -m flask --app app run --host=0.0.0.0 --cert=/var/www/certs_iot/cert.pem --key=/var/www/certs_iot/key.pem --port=5001";
      StartLimitBurst = "30";
      RestartSec = "5s";
    };
  };
}
