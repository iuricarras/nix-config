# Specifications For Differentiating Hosts
{
  config,
  lib,
  ...
}: {
  options.hostSpec = lib.mkOption {
    type = lib.types.submodule {
      freeformType = with lib.types; attrsOf str;
      options = {
        # Data variables that don't dictate configuration settings
        username = lib.mkOption {
          type = lib.types.str;
          description = "The username of the host";
        };
        hostName = lib.mkOption {
          type = lib.types.str;
          description = "The hostname of the host";
        };
        home = lib.mkOption {
          type = lib.types.str;
          description = "The home directory of the user";
          default = "/home/${config.hostSpec.username}";
        };
        server = lib.mkOption {
          type = lib.types.attrsOf lib.types.anything;
          description = "An attribute set containing server-specific configuration options";
        };

        # Configuration Settings
        isMinimal = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Used to indicate a minimal host";
        };
        isServer = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Used to indicate a server host";
        };
        isWork = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Used to indicate a host that uses work resources";
        };
        isMeri = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Activates Meri's configuration";
        };
        isLaptop = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Used to indicate a laptop host";
        };
        isDEGnome = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Used to indicate a host that uses the GNOME desktop environment";
        };
        isDEPlasma = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Used to indicate a host that uses the KDE Plasma desktop environment";
        };
        isDECinnamon = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Used to indicate a host that uses the Cinnamon desktop environment";
        };
        isWMHyprland = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Used to indicate a host that uses the Hyprland window manager";
        };
        isDECosmic = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Used to indicate a host that uses the Cosmic desktop environment";
        };
        wireguardUser = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Used to indicate a host that should have wireguard configuration applied to it. This is used to conditionally include the wireguard.nix file in the host configuration.";
        };
      };
    };
  };
  config = {
    assertions = [
      {
        assertion =
          !config.hostSpec.isServer || (config.hostSpec.isServer && !builtins.isNull config.hostSpec.server);
        message = "isServer is true but no server attribute set is provided";
      }
    ];
  };
}
