# Specifications For Differentiating Hosts
{
  config,
  lib,
  ...
}:
{
  options.hostSpec = {
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
    isDEGnome = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Used to indicate a host that uses the GNOME desktop environment";
    };
  };
}