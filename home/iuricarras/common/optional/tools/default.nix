{
  pkgs,
  config,
  ...
}: {
  imports = [
    ./vscode.nix
  ];

  home.packages = builtins.attrValues {
    inherit
      (pkgs)
      obs-studio
      github-desktop
      vlc
      shortwave # Radio Player
      obsidian
      deluge
      mpg123
    ;
    inherit
      (pkgs.obs-studio-plugins)
      obs-vaapi
      ;
    inherit
      (pkgs.kdePackages)
      kdenlive
      ;
  };
}
