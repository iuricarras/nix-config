{
  pkgs,
  ...
}: {
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  xdg.portal = {
    enable = true;
    extraPortals = [pkgs.xdg-desktop-portal-wlr];
    config.common.default = "*";
  };

  environment.systemPackages = with pkgs; [
    /*
         hyprcursor
      hyprpaper
      hyprpicker
      hyprlock
      kitty
      dunst
      libnotify
      waybar
      rofi-wayland
      xfce.thunar
    xfce.thunar-archive-plugin
    xfce.thunar-media-tags-plugin
    xfce.thunar-volman
      lxqt.lxqt-policykit
      papirus-icon-theme
      nordic
      networkmanagerapplet
      image-roll
    */
    hyprcursor
    hyprpaper
    hyprpicker
    hyprlock
    swaybg
    swayidle
    swaylock
    wlroots
    wl-clipboard
    waybar
    wofi
    foot
    mako
    grim
    slurp
    wf-recorder
    light
    yad
    xfce.thunar
    xfce.thunar-archive-plugin
    xfce.thunar-media-tags-plugin
    xfce.thunar-volman
    geany
    mpv
    mpd
    mpc-cli
    viewnior
    imagemagick
    lxqt.lxqt-policykit
    playerctl
    pastel
    pywal
    alacritty
    rofi
    pulsemixer
    libnotify
  ];

  programs.dconf.enable = true;
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.sddm.enableGnomeKeyring = true;
  fonts.packages = with pkgs; [
    font-awesome
  ];

  security.polkit.enable = true;
}
