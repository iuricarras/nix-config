{pkgs, ...}: {
  services = {
    desktopManager.plasma6.enable = true;
    displayManager = {
      sddm = {
        enable = true;
        #autoLogin = {
        #  enable = true;
        #  user = "${cfg.userName}";
        #};
      };
      defaultSession = "plasma";
    };
  };

  programs.dconf.enable = true;
  environment.systemPackages = with pkgs; [
    kdePackages.kalk
    kdePackages.plasma-browser-integration
    haruna
  ];
}
