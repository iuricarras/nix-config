{pkgs, ...}: {
  # Programs and configurations (host level) used on my masters degree

  #Security
  services.mongodb = {
    enable = true;
    package = pkgs.mongodb-ce;
  };
}
