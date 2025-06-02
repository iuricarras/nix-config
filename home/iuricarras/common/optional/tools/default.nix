{pkgs, ...}:{
  home.packages = builtins.attrValues {
    inherit
      (pkgs)
      obs-studio
      postman
      winbox
      github-desktop
      vlc
      ;
      inherit (pkgs.obs-studio-plugins)
      obs-vaapi
      ;
      inherit (pkgs.kdePackages)
      kdenlive
      ;
  };
}