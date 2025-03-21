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

  nixpkgs.overlays = [
    # GNOME 46: triple-buffering-v4-46
    (final: prev: {
      gnome = prev.gnome.overrideScope (gnomeFinal: gnomePrev: {
        mutter = gnomePrev.mutter.overrideAttrs (old: {
          src = pkgs.fetchFromGitLab {
            domain = "gitlab.gnome.org";
            owner = "vanvugt";
            repo = "mutter";
            rev = "triple-buffering-v4-46";
            hash = "sha256-C2VfW3ThPEZ37YkX7ejlyumLnWa9oij333d5c4yfZxc=";
          };
        });
      });
    })
  ];

  environment.systemPackages = with pkgs; [
    gnome-tweaks
    gnomeExtensions.appindicator
    gnomeExtensions.ideapad
    gnomeExtensions.tiling-assistant
    gnomeExtensions.dash-to-dock
    papirus-icon-theme
    yaru-theme
    ubuntu_font_family
    ubuntu-themes
  ];
}
