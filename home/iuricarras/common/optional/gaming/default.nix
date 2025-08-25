# This module just provides a customized .desktop file with gamescope args dynamically created based on the
# host's monitors configuration
{
  pkgs,
  config,
  lib,
  ...
}: let
  monitor = lib.head (lib.filter (m: m.primary) config.monitors);

  prismlauncher = pkgs.prismlauncher.override {jdks = [pkgs.jdk8 pkgs.jdk17 pkgs.jdk21];};

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
    
    truckersmpcli = let
      truckersString = lib.concatStringsSep " " [
        (lib.getExe pkgs.nur.repos.iuricarras.truckersmp-cli)
        "-vv start ets2mp -r dx11"
      ];
    in
      pkgs.writeTextDir "share/applications/truckersmp-cli.desktop" ''
        [Desktop Entry]
        Name=TruckersMP
        Exec=${truckersString}
        Icon=${./icons8-truckersmp-480.png}
        Type=Application
      '';
in {
  home.packages =
    [
      steam-session
      prismlauncher
      truckersmpcli
      (pkgs.bottles.override {removeWarningPopup = true;})
    ]
    ++ builtins.attrValues {
      inherit
        (pkgs)
        path-of-building
        rpcs3
        pcsx2
        ppsspp-sdl-wayland
        protonplus
        wine
        winetricks
        steamcmd
        protonup-qt
        #lutris
        mangohud
        piper
        goverlay
        heroic
        cartridges
        ;
    };
}
