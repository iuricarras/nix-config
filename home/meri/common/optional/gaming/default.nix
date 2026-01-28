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
in {
  home.packages =
    [
      prismlauncher
      (pkgs.bottles.override {removeWarningPopup = true;})
    ]
    ++ builtins.attrValues {
      inherit
        (pkgs)
        protonplus
        wine
        winetricks
        steamcmd
        protonup-qt
        heroic
        ;
    };
}
