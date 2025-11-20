{pkgs, ...}: {
  # Programs and configurations (host level) used on my masters degree

  #Security
  services.mongodb = {
    enable = true;
    package = pkgs.mongodb-ce;
  };

  services.httpd.enable = true;
  services.httpd.adminAddr = "webmaster@example.org";
  services.httpd.enablePHP = true; # oof... not a great idea in my opinion
  services.httpd.user = "iuricarras";

  services.httpd.virtualHosts."ssi.local" = {
    documentRoot = "/home/iuricarras/Mestrado/SSI/Lab09";
    locations = {
      "/" = {
      index = "index.php index.html";
    };
    };
    # want ssl + a let's encrypt certificate? add `forceSSL = true;` right here
  };

  services.mysql.enable = true;
  services.mysql.package = pkgs.mariadb;


  # hacky way to create our directory structure and index page... don't actually use this
  systemd.tmpfiles.rules = [
    "d /var/www/ssi.local"
    "f /var/www/ssi.local/index.php - - - - <?php phpinfo();"
  ];

  networking.hosts ={
    "127.0.0.1" = ["ssi.local"];
  };
}
