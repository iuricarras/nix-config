{ lib , config , pkgs, ... }:
let
sleek-grub-theme = pkgs.sleek-grub-theme.override {withBanner="Henlo Meri!"; withStyle="orange";};

in {
  boot = {
	  supportedFilesystems = [ "ntfs" ];
	  loader = {
      efi.canTouchEfiVariables = true;
      grub = {
        device = "nodev";
        efiSupport = true;
        enable = true;
        useOSProber = true;
        timeoutStyle = "menu";
        default = "saved";
        configurationLimit = 5;
        theme = lib.mkIf config.hostSpec.isMeri "${sleek-grub-theme}";
      };
      timeout = 20;
    };
  };
}
