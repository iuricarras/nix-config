{pkgs, ...}: {
  services.xserver = {
    desktopManager.gnome = {
      enable = true;
      #extraGSettingsOverridePackages = [pkgs.gnome.mutter];
      #extraGSettingsOverrides = ''
      #  [org.gnome.mutter]
      #  experimental-features=['variable-refresh-rate', 'scale-monitor-framebuffer']
      #'';
    };
    displayManager.gdm.enable = true;
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
}
