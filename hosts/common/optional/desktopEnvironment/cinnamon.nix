{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.desktop.cinnamon;
in {
  options.desktop.cinnamon.enable = mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable Cinnamon desktop environment and related packages.";
  };
  config = mkIf cfg.enable {
    services = {
      cinnamon.apps.enable = true;
      xserver = {
        enable = true;
        displayManager.lightdm.enable = true;
        desktopManager = {
          cinnamon.enable = true;
        };
      };
      displayManager.defaultSession = "cinnamon";
    };
  };
}
