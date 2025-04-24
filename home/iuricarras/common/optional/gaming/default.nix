# This module just provides a customized .desktop file with gamescope args dynamically created based on the
# host's monitors configuration
{
  pkgs,
  config,
  lib,
  inputs,
  ...
}: let
  monitor = lib.head (lib.filter (m: m.primary) config.monitors);

  prismlauncher = pkgs.prismlauncher.override{jdks = [ pkgs.jdk8 pkgs.jdk17 pkgs.jdk21]; };

  steam-session = let
    gamescope = lib.concatStringsSep " " [
      (lib.getExe pkgs.gamescope)
      "--output-width ${toString monitor.width}"
      "--output-height ${toString monitor.height}"
      "--framerate-limit ${toString monitor.refreshRate}"
      "--prefer-output ${monitor.name}"
      "--adaptive-sync"
      "--expose-wayland"
    ];
    steam = lib.concatStringsSep " " [
      "steam"
      #"steam://open/bigpicture"
    ];
  in
    pkgs.writeTextDir "share/applications/steam-session.desktop" ''
      [Desktop Entry]
      Name=Steam Session
      Exec=${gamescope} -- ${steam}
      Icon=steam
      Type=Application
    '';
in {
  home.packages =
    [
      steam-session
      prismlauncher
    ]
    ++ builtins.attrValues {
      inherit
        (pkgs)
        
        path-of-building
        rpcs3
        pcsx2
        wine
        winetricks
        steamcmd
        protonup-qt
        lutris
        mangohud
        piper
        goverlay
        
        ;
    };
}
