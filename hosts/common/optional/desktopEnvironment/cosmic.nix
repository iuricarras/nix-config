{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.desktop.cosmic;
in {
  options.desktop.cosmic.enable = mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable Cosmic desktop environment and related packages.";
  };
  config = mkIf cfg.enable {
    services = {
      displayManager.cosmic-greeter.enable = true;
      desktopManager.cosmic.enable = true;
      system76-scheduler.enable = true;
    };
    environment.systemPackages = with pkgs; [       mate.engrampa
 ];
  };
}
