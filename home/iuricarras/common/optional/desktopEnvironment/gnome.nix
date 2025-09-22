{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.desktop.gnome;
in {
  options.desktop.gnome.enable = mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable GNOME desktop environment user configurations.";
  };

  config = mkIf cfg.enable {
    gtk = {
      enable = true;
      theme = {
        name = "Yaru";
        package = pkgs.yaru-theme;
      };
      iconTheme = {
        name = "Papirus";
        package = pkgs.papirus-icon-theme;
      };
      cursorTheme = {
        name = "Yaru";
        package = pkgs.yaru-theme;
      };
    };

    home.sessionVariables.GTK_THEME = "Yaru";
  };
}
