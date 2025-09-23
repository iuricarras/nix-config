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
    # Theme settings for GTK applications
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

      gtk3.extraConfig = {
        Settings = ''

          gtk-application-prefer-dark-theme=0

        '';
      };

      gtk4.extraConfig = {
        Settings = ''

          gtk-application-prefer-dark-theme=0

        '';
      };
    };
    dconf.enable = true;
    dconf.settings = {
      "org/gnome/shell" = {
        favorite-apps = [
          "firefox.desktop"
          "org.gnome.Nautilus.desktop"
          "code.desktop"
          "org.gnome.Console.desktop"
        ];
        disable-user-extensions = false;

        enabled-extensions = [
          "user-theme@gnome-shell-extensions.gcampax.github.com"
          "dash-to-dock@micxgx.gmail.com"
          "AlphabeticalAppGrid@stuarthayhurst"
          "appindicatorsupport@rgcjonas.gmail.com"
        ];

        "org/gnome/shell/extensions/user-theme" = "Yaru";
      };
      "org/gnome/desktop/interface" = {
        color-scheme = "default";
        gtk-theme = "Yaru";
        icon-theme = "Papirus";
        cursor-theme = "Yaru";
      };
    };

    home.packages = with pkgs; [
      gnomeExtensions.user-themes
      gnomeExtensions.dash-to-dock
      gnomeExtensions.alphabetical-app-grid
      gnomeExtensions.appindicator
      yaru-theme
      dconf-editor
    ];
  };
}
