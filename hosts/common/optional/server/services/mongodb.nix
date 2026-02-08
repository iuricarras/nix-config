{pkgs, ...}:{
    services.mongodb = {
    enable = true;
    package = pkgs.mongodb-ce;
    enableAuth = true;
    initialRootPasswordFile = "/etc/mongodbroot";
    bind_ip = "0.0.0.0";
  };
}