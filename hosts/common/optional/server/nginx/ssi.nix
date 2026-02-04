{
  pkgs,
  config,
  ...
}: let
  app = "bitsofme";
  appDomain = "bitsofme.pt";
  appDomainApi = "api.bitsofme.pt";
  dataDir = "/var/www/${app}/public";
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
      ${appDomain} = {
        root = "${dataDir}";
        forceSSL = true;
        sslCertificate = "/var/www/certs_ssi/cert.pem";
        sslCertificateKey = "/var/www/certs_ssi/key.pem";
        
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
      ${appDomainApi} = {
        forceSSL = true;
        sslCertificate = "/var/www/certs_ssi/cert.pem";
        sslCertificateKey = "/var/www/certs_ssi/key.pem";

        locations."/" = {
          proxyPass = "https://127.0.0.1:5000";
          recommendedProxySettings = true;
          proxyWebsockets = true;
        };
      };
    };
  };

  systemd.services.bitsofme = let
    python = pkgs.python313.withPackages (ppkgs:
      with ppkgs; [
        flask
        flask-jwt-extended
        flask-mail
        flask-cors
        flasgger
        pymongo
        python-dotenv
        pyjwt
        cryptography
      ]);
  in {
    wantedBy = ["multi-user.target"];
    after = ["network.target"];
    description = "Bits of Me";
    serviceConfig = {
      User = "bitsofme";
      Group = "bitsofme";
      Restart = "always";
      WorkingDirectory = "/var/www/bitsofme";
      ExecStart = "${python}/bin/python -m flask --app app run --host=0.0.0.0 --cert=/var/www/certs_ssi/cert.pem --key=/var/www/certs_ssi/key.pem --port=5000";
      StartLimitBurst = "30";
      RestartSec = "5s";
    };
  };
}
