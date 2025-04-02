{pkgs, ...}:{
  home.packages = builtins.attrValues {
    inherit
      (pkgs)
      obs-studio
      postman
      ;
      inherit (pkgs.obs-studio-plugins)
      obs-vaapi
      ;
      inherit (pkgs.kdePackages)
      kdenlive
      ;
  };
}