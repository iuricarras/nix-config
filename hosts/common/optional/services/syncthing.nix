{ lib, config, pkgs, ... }:

let
  cfg = config.syncthing;
in
{
  options.syncthing = {
    enable
      = lib.mkEnableOption "enable syncthing module";

    userName = lib.mkOption {
      default = "iuricarras";
      description = ''
        username
      '';
    };
  };

  config = lib.mkIf cfg.enable {
     services.syncthing = {
      enable = true;
      user = "${cfg.userName}";
      dataDir = "/home/${cfg.userName}/.syncthing";
      configDir = "/home/${cfg.userName}/.config/syncthing";
    };
  };
}
