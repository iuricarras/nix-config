{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.desktop.plasma;
in {
  options.desktop.plasma.enable = mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable Plasma desktop environment user configurations.";
  };

  config = mkIf cfg.enable {
    home.file.".config/kate/lspclient/settings.json".text = ''
        {
            "servers": {
                "nix": {
                    "command": ["nixd"],
                    "url": "https://github.com/nix-community/nixd",
                    "highlightingModeRegex": "^Nix$"
                }
            }
        }
    '';
  };
}
