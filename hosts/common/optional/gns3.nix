# See also /home/iuricarras/common/optional/gns3.nix
{pkgs, ...}: {
  #Install GNS3 GUI and server
  environment.systemPackages = builtins.attrValues {
    inherit
      (pkgs)
      gns3-gui
      gns3-server
      dynamips
      vpcs
      ubridge
      wireshark
      ;
  };

  #Configure Ubridge
  users.groups.ubridge = {};

  security.wrappers.ubridge = {
    source = "${pkgs.ubridge}/bin/ubridge";
    capabilities = "cap_net_admin,cap_net_raw=ep";
    owner = "root";
    group = "ubridge";
    permissions = "u+rx,g+rx,o+rx";
  };
}
