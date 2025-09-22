{
  lib,
  config,
  ...
}: {
  imports = [
    ./gnome.nix
  ];

  desktop.gnome.enable = lib.mkIf config.hostSpec.isDEGnome true;
}
