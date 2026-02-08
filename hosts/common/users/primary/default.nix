# User config applicable to both nixos and darwin
{
  inputs,
  pkgs,
  config,
  lib,
  ...
}: let
  hostSpec = config.hostSpec;
  pubKeys = lib.filesystem.listFilesRecursive ./keys;
  ifTheyExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
  sopsHashedPasswordFile = lib.optionalString (!config.hostSpec.isMinimal) config.sops.secrets."passwords/${hostSpec.username}".path;
in
  {
    #users.mutableUsers = false;
    users.users.${hostSpec.username} = {
      name = hostSpec.username;
      home = "/home/${hostSpec.username}";
      isNormalUser = true;
      #hashedPasswordFile = sopsHashedPasswordFile; # Blank if sops is not working.
      # These get placed into /etc/ssh/authorized_keys.d/<name> on nixos
      openssh.authorizedKeys.keys = lib.lists.forEach pubKeys (key: builtins.readFile key);

      # Add the user to the wheel group, and any other groups that exist
      extraGroups = lib.flatten [
        "wheel"
        (ifTheyExist [
          "audio"
          "video"
          "docker"
          "git"
          "networkmanager"
          "scanner" # for print/scan"
          "lp" # for print/scan"
          "ubridge" # for gns3
          "kvm" # for qemu
          "libvirtd" # for qemu
          "wireshark" # for wireshark

          #Server
          "streaming" # for arr services
        ])
      ];
    };

    programs.git.enable = true;

    # Create ssh sockets directory for controlpaths when homemanager not loaded (i.e. isMinimal)
    systemd.tmpfiles.rules = let
      user = config.users.users.${hostSpec.username}.name;
      group = config.users.users.${hostSpec.username}.group;
    in
      # you must set the rule for .ssh separately first, otherwise it will be automatically created as root:root and .ssh/sockects will fail
      [
        "d /home/${hostSpec.username}/.ssh 0750 ${user} ${group} -"
        "d /home/${hostSpec.username}/.ssh/sockets 0750 ${user} ${group} -"
      ];
  }
  # Import the user's personal/home configurations, unless the environment is minimal
  // lib.optionalAttrs (inputs ? "home-manager") {
    home-manager = {
      extraSpecialArgs = {
        inherit pkgs inputs;
        hostSpec = config.hostSpec;
      };
      users.${hostSpec.username}.imports = lib.flatten (
        lib.optional (!hostSpec.isMinimal) [
          (
            {config, ...}:
              import (lib.custom.relativeToRoot "home/${hostSpec.username}/${hostSpec.hostName}.nix") {
                inherit
                  pkgs
                  inputs
                  config
                  lib
                  hostSpec
                  ;
              }
          )
        ]
      );
    };
  }
