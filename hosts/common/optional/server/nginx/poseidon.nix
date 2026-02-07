{
  pkgs,
  lib,
  config,
  ...
}: {
  services.nginx = {
    virtualHosts."poseidon.gaiaserver.pt" = {
      forceSSL = true;
      sslCertificate = "/var/www/certs/cert";
      sslCertificateKey = "/var/www/certs/key";
      root = "/var/www/poseidon/public";
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
      locations."^~ /radarr" = {
        proxyPass = "http://127.0.0.1:7878";
        extraConfig = ''
          proxy_set_header Host $host;
          proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
          proxy_set_header X-Forwarded-Host $host;
          proxy_set_header X-Forwarded-Proto $scheme;
          proxy_redirect off;
          proxy_http_version 1.1;
          proxy_set_header Upgrade $http_upgrade;
          proxy_set_header Connection $http_connection;
        '';
      };
      locations."^~ /radarr/api" = {
        proxyPass = "http://127.0.0.1:7878";
        extraConfig = ''
          auth_basic off;
        '';
      };

      locations."^~ /prowlarr" = {
        proxyPass = "http://127.0.0.1:9696";
        extraConfig = ''
          proxy_set_header Host $host;
          proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
          proxy_set_header X-Forwarded-Host $host;
          proxy_set_header X-Forwarded-Proto $scheme;
          proxy_redirect off;
          proxy_http_version 1.1;
          proxy_set_header Upgrade $http_upgrade;
          proxy_set_header Connection $http_connection;
        '';
      };
      locations."^~ /prowlarr(/[0-9]+)?/api" = {
        proxyPass = "http://127.0.0.1:9696";
        extraConfig = ''
          auth_basic off;
        '';
      };

      locations."^~ /sonarr" = {
        proxyPass = "http://127.0.0.1:8989";
        extraConfig = ''
          proxy_set_header Host $host;
          proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
          proxy_set_header X-Forwarded-Host $host;
          proxy_set_header X-Forwarded-Proto $scheme;
          proxy_redirect off;
          proxy_http_version 1.1;
          proxy_set_header Upgrade $http_upgrade;
          proxy_set_header Connection $http_connection;
        '';
      };
      locations."^~ /sonarr/api" = {
        proxyPass = "http://127.0.0.1:8989";
        extraConfig = ''
          auth_basic off;
        '';
      };
    };
  };
}
