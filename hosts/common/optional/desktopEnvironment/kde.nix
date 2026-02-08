{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.desktop.plasma;
in {
  options.desktop.plasma.enable = mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable KDE Plasma desktop environment and related packages.";
  };
  config = mkIf cfg.enable {
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

    hardware.bluetooth.enable = true;

    programs.dconf.enable = true;
    environment.systemPackages = with pkgs; [
      kdePackages.kalk
      kdePackages.plasma-browser-integration
      haruna
    ];
    
    programs.ssh = {
      startAgent = true;
      enableAskPassword = true;
    };

    environment.variables = {
      SSH_ASKPASS_REQUIRE = "prefer";
    };
  };
}
