{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.desktop.pantheon;
in {
  options.desktop.pantheon.enable = mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable Pantheon desktop environment and related packages.";
  };
  config = mkIf cfg.enable {
    environment = {
      # pantheon.excludePackages = with pkgs.pantheon; [
      #   elementary-music
      #   elementary-photos
      #   elementary-videos
      #   epiphany
      # ];

      # App indicator
      # - https://discourse.nixos.org/t/anyone-with-pantheon-de/28422
      # - https://github.com/NixOS/nixpkgs/issues/144045#issuecomment-992487775
      pathsToLink = ["/libexec"];

      # Add additional apps and include Yaru for syntax highlighting
      systemPackages = with pkgs; [
        appeditor # elementary OS menu editor
        celluloid # Video Player
        formatter # elementary OS filesystem formatter
        gthumb # Image Viewer
        simple-scan # Scanning
        indicator-application-gtk3 # App Indicator
        yaru-theme
        pantheon-tweaks
      ];
    };

    # Add GNOME Disks and Seahorse
    programs = {
      gnome-disks.enable = true;
      seahorse.enable = true;
    };

    services = {
      pantheon.apps.enable = true;

      xserver = {
        enable = true;
        displayManager = {
          lightdm.enable = true;
          lightdm.greeters.pantheon.enable = true;
        };

        desktopManager = {
          pantheon = {
            enable = true;
            extraWingpanelIndicators = with pkgs; [
              monitor
              wingpanel-indicator-namarupa
            ];
          };
        };
      };
    };

    # App indicator
    # - https://github.com/NixOS/nixpkgs/issues/144045#issuecomment-992487775
    systemd.user.services.indicatorapp = {
      description = "indicator-application-gtk3";
      wantedBy = ["graphical-session.target"];
      partOf = ["graphical-session.target"];
      serviceConfig = {
        ExecStart = "${pkgs.indicator-application-gtk3}/libexec/indicator-application/indicator-application-service";
      };
    };
  };
}
