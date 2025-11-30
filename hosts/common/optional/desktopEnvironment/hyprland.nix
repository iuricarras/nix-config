{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
with lib; let
  cfg = config.desktop.hyprland;
in {
  options.desktop.hyprland.enable = mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable Hyprland window manager and related packages.";
  };

  config = mkIf cfg.enable {
    programs.hyprland = {
      enable = true;
      xwayland.enable = true;
    };

    services.displayManager.sddm = {
      enable = true;
      wayland.enable = true;
      theme = "sddm-astronaut-theme";
      extraPackages = with pkgs; [
        kdePackages.qtsvg
        kdePackages.qtmultimedia
        kdePackages.qtvirtualkeyboard
      ];
    };
    services.gnome.gnome-keyring.enable = true;
    security.polkit.enable = true;
    security.pam.services.sddm.enableGnomeKeyring = true;
    services.gvfs.enable = true; # Mount, trash, and other functionalities
    services.tumbler.enable = true; # Thumbnail generation
    environment.systemPackages = with pkgs; [
      hyprlock
      hypridle
      hyprpicker
      hyprpaper
      hyprsunset
      hyprland-qtutils
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
      geany
      mpv
      mpd
      mpc
      viewnior
      imagemagick
      playerctl
      pastel
      pywal
      alacritty
      rofi
      pulsemixer
      glib
      libnotify
      inputs.sddm-themes.packages.x86_64-linux.archcraft
      xfce.thunar-archive-plugin
      xfce.thunar-volman
      sddm-astronaut
      networkmanager_dmenu
      libsecret
    ];

    xdg.portal = {
      enable = true;
      extraPortals = [pkgs.xdg-desktop-portal-hyprland pkgs.xdg-desktop-portal-gtk pkgs.xdg-desktop-portal];
      config.common.default = "*";
    };
    services.udev.extraRules = ''
      ACTION=="add", SUBSYSTEM=="backlight", RUN+="${pkgs.coreutils}/bin/chgrp video %S%p/brightness", RUN+="${pkgs.coreutils}/bin/chmod g+w %S%p/brightness"
    '';

    services.udev.path = [
      pkgs.coreutils # for chgrp
    ];
  };
}
