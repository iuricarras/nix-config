{
  lib,
  pkgs,
  config,
  ...
}: {
  hardware.xone.enable = true; # xbox controller
  
  programs = {
    steam = {
      enable = true;
      gamescopeSession.enable = true;
      protontricks = {
        enable = true;
        package = pkgs.protontricks;
      };
      package = pkgs.steam.override {
        extraPkgs = pkgs: let
          xorgPkgs = with pkgs.xorg; [
            libXcursor
            libXi
            libXinerama
            libXScrnSaver
          ];
          stdenvPkgs = [
            pkgs.stdenv.cc.cc.lib
          ];
          otherPkgs = with pkgs;
            [
              libpng
              libpulseaudio
              libvorbis
              libkrb5
              keyutils
              gperftools
            ]
            ++ lib.optionals config.hostSpec.isDEGnome [yaru-theme] 
            ++ lib.optionals config.hostSpec.isDEPlasma [ kdePackages.breeze ];
        in
          xorgPkgs ++ stdenvPkgs ++ otherPkgs;
      };
      extraCompatPackages = [pkgs.unstable.proton-ge-bin];
    };
    #gamescope launch args set dynamically in home/<user>/common/optional/gaming
    gamescope = {
      enable = true;
      #capSysNice = true;
    };
    # to run steam games in game mode, add the following to the game's properties from within steam
    # gamemoderun %command%
    gamemode = {
      enable = true;
      settings = {
        #see gamemode man page for settings info
        general = {
          softrealtime = "on";
          inhibit_screensaver = 1;
        };
        gpu = {
          apply_gpu_optimisations = "accept-responsibility";
          gpu_device = 1; # The DRM device number on the system (usually 0), ie. the number in /sys/class/drm/card0/
          amd_performance_level = "high";
        };
        # custom = {
        #   start = "${pkgs.libnotify}/bin/notify-send 'GameMode started'";
        #   end = "${pkgs.libnotify}/bin/notify-send 'GameMode ended'";
        # };
      };
    };
  };

  environment.systemPackages = with pkgs; [
    nur.repos.iuricarras.truckersmp-cli
  ];
}
