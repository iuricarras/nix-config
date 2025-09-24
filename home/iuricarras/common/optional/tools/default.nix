{pkgs, config, ...}:
let
homeDirectory = config.home.homeDirectory;
in{
  home.packages = builtins.attrValues {
    inherit
      (pkgs)
      obs-studio
      #postman
      winbox
      github-desktop
      vlc
      shortwave # Radio Player
      obsidian
      ;
      inherit (pkgs.obs-studio-plugins)
      obs-vaapi
      ;
      inherit (pkgs.kdePackages)
      kdenlive
      ;
  };

  home.file.".config/Code/User/settings.json".text = ''
    {
      "github.copilot.nextEditSuggestions.enabled": true,
      "files.autoSave": "afterDelay",
      "nix.serverPath": "nixd",
      "nix.enableLanguageServer": true,
      "nix.serverSettings": {
        "nixd": {
          "formatting": {
            "command": [ "alejandra" ], // or nixfmt or nixpkgs-fmt
          },
          // "options": {
          //    "nixos": {
          //      "expr": "(builtins.getFlake \"/PATH/TO/FLAKE\").nixosConfigurations.CONFIGNAME.options"
          //    },
          //    "home_manager": {
          //      "expr": "(builtins.getFlake \"/PATH/TO/FLAKE\").homeConfigurations.CONFIGNAME.options"
          //    },
          // },
        }
      }
    }
  '';


}
