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
        theme = if config.hostSpec.isMeri then "${sleek-grub-theme}" else "${pkgs.kdePackages.breeze-grub}/grub/themes/breeze";
      };
      timeout = 20;
    };
  };
}
