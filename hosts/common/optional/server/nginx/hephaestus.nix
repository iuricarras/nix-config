{
  pkgs,
  lib,
  config,
  ...
}: let
  app = "pterodactyl";
  appDomain = "hephaestus.gaiaserver.pt";
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
        sslCertificate = "/var/www/certs/cert";
        sslCertificateKey = "/var/www/certs/key";

        extraConfig = ''
          index index.php;
        '';

        locations."/" = {
          extraConfig = ''
              # First attempt to serve request as file, then
              # as directory, then fall back to displaying a 404.
            try_files $uri $uri/ /index.php?$query_string;
          '';
        };

        locations."~ ^(.+\\.php)(.*)$" = {
          extraConfig = ''
            # Check that the PHP script exists before passing it
            include ${config.services.nginx.package}/conf/fastcgi_params;
            fastcgi_split_path_info  ^(.+\.php)(.*)$;
            fastcgi_pass unix:${config.services.phpfpm.pools.${app}.socket};
            fastcgi_param  PATH_INFO        $fastcgi_path_info;
            fastcgi_index index.php;
            fastcgi_param PHP_VALUE "upload_max_filesize = 100M \n post_max_size=100M";
            fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
            fastcgi_param HTTP_PROXY "";
            fastcgi_intercept_errors off;
            fastcgi_buffer_size 16k;
            fastcgi_buffers 4 16k;
            fastcgi_connect_timeout 300;
            fastcgi_send_timeout 300;
            fastcgi_read_timeout 300;
            include ${pkgs.nginx}/conf/fastcgi.conf;
          '';
        };
      };
    };
  };

  services.redis.servers."redisserver".enable = true;
  services.redis.servers."redisserver".port = 6379;

  services.cron = {
    enable = true;
    systemCronJobs = [
      "* * * * * php /var/www/pterodactyl/artisan schedule:run >> /dev/null 2>&1"
    ];
  };

  systemd.services.ptero = {
    wantedBy = ["multi-user.target"];
    after = ["redis-redisserver.service"];
    description = "Pterodactyl Queue Worker";
    serviceConfig = {
      User = "nginx";
      Group = "nginx";
      Restart = "always";
      ExecStart = "${pkgs.php}/bin/php /var/www/pterodactyl/artisan queue:work --queue=high,standard,low --sleep=3 --tries=3";
      StartLimitBurst = "30";
      RestartSec = "5s";
    };
  };

  systemd.services.wings = {
    wantedBy = ["multi-user.target"];
    after = ["docker.service"];
    requires = ["docker.service"];
    partOf = ["docker.service"];
    description = "Pterodactyl Wings Daemon";
    serviceConfig = {
      User = "root";
      WorkingDirectory = "/etc/pterodactyl";
      LimitNOFILE = "4096";
      PIDFile = "/var/run/wings/daemon.pid";
      Restart = "on-failure";
      ExecStart = "${pkgs.nur.repos.xddxdd.pterodactyl-wings}/bin/wings";
      StartLimitBurst = "30";
      RestartSec = "5s";
    };
  };

  environment.systemPackages = with pkgs; [
    nur.repos.xddxdd.pterodactyl-wings
  ];
}
