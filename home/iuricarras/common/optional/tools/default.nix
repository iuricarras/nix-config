{
  pkgs,
  ...
}: {

imports = [
./vscode.nix
];

  home.packages = builtins.attrValues {
    inherit
      (pkgs)
      obs-studio
      #postman
      winbox
      github-desktop
      vlc
      shortwave # Radio Player
      obsidian
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
