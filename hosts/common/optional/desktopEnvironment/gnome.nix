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
    description = "Enable GNOME desktop environment and related packages.";
  };

  config = mkIf cfg.enable {
    services = {
      desktopManager.gnome.enable = true;
      displayManager.gdm.enable = true;
      # Uncomment and adjust if you want to use extra GSettings overrides:
      desktopManager.gnome.extraGSettingsOverridePackages = [pkgs.mutter];
      desktopManager.gnome.extraGSettingsOverrides = ''
        [org.gnome.mutter]
        experimental-features=['variable-refresh-rate', 'scale-monitor-framebuffer']
      '';
    };
    programs.dconf.enable = true;
    environment.systemPackages = builtins.attrValues {
      inherit
        (pkgs)
        gnome-tweaks
        papirus-icon-theme
        yaru-theme
        ubuntu_font_family
        ubuntu-themes
        ubuntu-sans
        ;

      inherit
        (pkgs.gnomeExtensions)
        appindicator
        ideapad
        tiling-assistant
        dash-to-dock
        user-themes
        alphabetical-app-grid
        ;
    };
  };
}
