{
  lib,
  config,
  ...
}: {
  imports = [
    ./gnome.nix
    ./kde.nix
    ./cinnamon.nix
    ./hyprland.nix
    ./cosmic.nix
  ];

  desktop.gnome.enable = lib.mkIf config.hostSpec.isDEGnome true;
  desktop.plasma.enable = lib.mkIf config.hostSpec.isDEPlasma true;
  desktop.cinnamon.enable = lib.mkIf config.hostSpec.isDECinnamon true;
  desktop.hyprland.enable = lib.mkIf config.hostSpec.isWMHyprland true;
  desktop.cosmic.enable = lib.mkIf config.hostSpec.isDECosmic true;
}
