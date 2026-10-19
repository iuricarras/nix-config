{
  config,
  pkgs,
  ...
}: let
  hostname = config.hostSpec.server.hostname;
in {
  services.authelia.instances.main = {
    enable = true;
    secrets = {
      jwtSecretFile = "/var/lib/authelia-main/jwt-secret";
      storageEncryptionKeyFile = "/var/lib/authelia-main/storage-encryption-file";
      sessionSecretFile = "/var/lib/authelia-main/session-secret-file";
    };
    settings = {
      theme = "dark";
      default_redirection_url = "https://${hostname}";
      server = {
        host = "127.0.0.1";
        port = 9091;
      };
      log = {
        level = "debug";
        format = "text";
      };

      authentication_backend = {
        file = {
          path = "/var/lib/authelia-main/users_database.yml";
        };
      };

      access_control = {
        default_policy = "deny";
        rules = [
          {
            domain = ["auth.${hostname}"];
            policy = "bypass";
          }
          {
            domain = ["*.${hostname}"];
            policy = "one_factor";
          }
        ];
      };

      session = {
        name = "authelia_session";
        expiration = "12h";
        inactivity = "45m";
        remember_me_duration = "1M";
        domain = "${hostname}";
        redis.host = "/run/redis-authelia-main/redis.sock";
      };

      regulation = {
        max_retries = 3;
        find_time = "5m";
        ban_time = "15m";
      };

      storage = {
        local = {
          path = "/var/lib/authelia-main/db.sqlite3";
        };
      };

      notifier = {
        disable_startup_check = false;
        filesystem = {
          filename = "/var/lib/authelia-main/notification.txt";
        };
      };
    };
  };
  services.redis.servers.authelia-main = {
    enable = true;
    user = "authelia-main";
    port = 0;
    unixSocket = "/run/redis-authelia-main/redis.sock";
    unixSocketPerm = 600;
  };
  services.nginx.virtualHosts."auth.${hostname}" = {
    forceSSL = true;
    sslCertificate = "${config.sops.secrets."certs/pub".path}";
    sslCertificateKey = "${config.sops.secrets."certs/key".path}";

    locations."/" = {
      proxyPass = "http://127.0.0.1:9091";
      proxyWebsockets = true;
    };
  };
}
