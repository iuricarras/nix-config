{
  lib,
  config,
  ...
}: {
  imports = [
    ./gnome.nix
    ./kde.nix
  ];

  desktop.gnome.enable = lib.mkIf config.hostSpec.isDEGnome true;
  desktop.plasma.enable = lib.mkIf config.hostSpec.isDEPlasma true;
}
