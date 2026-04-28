## List of packages and configuration used on my masters' degree
{pkgs, ...}: let
  idea = pkgs.jetbrains.idea.override {forceWayland = true;};
in {
  home.packages = builtins.attrValues {
    inherit
      (pkgs)
      postman
      netbeans
      unityhub
      arduino-ide
      autopsy
      sleuthkit
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
