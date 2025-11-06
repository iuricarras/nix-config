{
  lib,
  config,
  ...
}: {
  imports = [
    ./gnome.nix
    ./plasma.nix
  ];

  desktop.gnome.enable = lib.mkIf config.hostSpec.isDEGnome true;
  desktop.plasma.enable = lib.mkIf config.hostSpec.isDEPlasma true;
}
