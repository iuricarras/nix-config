{...}:{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
with lib; let
  cfg = config.desktop.hyprland;
  archcraft = inputs.sddm-themes.packages.x86_64-linux.archcraft;
in {
  options.desktop.hyprland.enable = mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable Hyprland window manager and related packages.";
  };

  config = mkIf cfg.enable {
    services = {
      desktopManager.hyprland = {
        enable = true;
        xwayland = true;
      };

      displayManager.sddm = {
        enable = true;
        theme = pkgs.archcraft;
      };
    };
  };
}