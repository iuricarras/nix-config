{
  lib,
  config,
  ...
}: {
  imports = [
    ./gnome.nix
    ./kde.nix
    ./cinnamon.nix
  ];

  desktop.gnome.enable = lib.mkIf config.hostSpec.isDEGnome true;
  desktop.plasma.enable = lib.mkIf config.hostSpec.isDEPlasma true;
  desktop.cinnamon.enable = lib.mkIf config.hostSpec.isDECinnamon true;
}
