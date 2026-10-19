# This module just provides a customized .desktop file with gamescope args dynamically created based on the
# host's monitors configuration
{
  pkgs,
  config,
  lib,
  ...
}: let

  prismlauncher = pkgs.prismlauncher.override {jdks = [pkgs.jdk8 pkgs.jdk17 pkgs.jdk21 pkgs.jdk25];};

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
  imports = [
    ./mangohud.nix
  ];
  home.packages =
    [      
      prismlauncher
      truckersmpcli
    ]
    ++ builtins.attrValues {
      inherit
        (pkgs)
        #rpcs3
        bottles
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
        volanta
        ;
    };
}
