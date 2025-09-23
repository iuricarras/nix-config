{ ... }:
{
  imports = [
    #
    # ========== Required Configs ==========
    #
    common/core

    #
    # ========== Host-specific Optional Configs ==========
    #
    common/optional/gaming
    common/optional/tools
    common/optional/desktopEnvironment

    common/optional/gns3.nix
    common/optional/sops.nix
  ];


   #
  # ========== Host-specific Monitor Spec ==========
  #
  # This uses the nix-config/modules/home/montiors.nix module which defaults to enabled.
  # Your nix-config/home-manger/<user>/common/optional/desktops/foo.nix WM config should parse and apply these values to it's monitor settings
  # If on hyprland, use `hyprctl monitors` to get monitor info.
  # https://wiki.hyprland.org/Configuring/Monitors/
  #    ------
  # | Internal |
  # | Display  |
  #    ------
  monitors = [
    {
      name = "DP-3";
      width = 1920;
      height = 1080;
      refreshRate = 144;
      primary = true;
      #vrr = 1;
    }
  ];


}