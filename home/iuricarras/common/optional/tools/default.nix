{
  pkgs,
  config,
  ...
}: let
  idea = pkgs.jetbrains.idea-ultimate.override {forceWayland = true;};
in {
  imports = [
    ./vscode.nix
  ];

  home.packages = builtins.attrValues {
    inherit
      (pkgs)
      obs-studio
      #postman
      github-desktop
      vlc
      shortwave # Radio Player
      obsidian
      netbeans
      deluge
      ;
    inherit
      (pkgs.obs-studio-plugins)
      obs-vaapi
      ;
    inherit
      (pkgs.kdePackages)
      kdenlive
      ;
    inherit
      idea
      ;
  };
}
