{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.desktop.gnome;
in
{
  options.desktop.gnome.enable = mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable GNOME desktop environment and related packages.";
  };

  config = mkIf cfg.enable {
    services.xserver = {
      desktopManager.gnome.enable = true;
      displayManager.gdm.enable = true;
      # Uncomment and adjust if you want to use extra GSettings overrides:
      # desktopManager.gnome.extraGSettingsOverridePackages = [ pkgs.gnome.mutter ];
      # desktopManager.gnome.extraGSettingsOverrides = ''
      #   [org.gnome.mutter]
      #   experimental-features=['variable-refresh-rate', 'scale-monitor-framebuffer']
      # '';
    };

    environment.systemPackages = with pkgs; [
      gnome-tweaks
      gnomeExtensions.appindicator
      gnomeExtensions.ideapad
      gnomeExtensions.tiling-assistant
      gnomeExtensions.dash-to-dock
      gnomeExtensions.user-themes
      papirus-icon-theme
      yaru-theme
      ubuntu_font_family
      ubuntu-themes
      ubuntu-sans
    ];
  };
}