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
      github-desktop
      vlc
      shortwave # Radio Player
      obsidian
      netbeans
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
