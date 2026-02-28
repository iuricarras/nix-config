{config, ...}: {
  networking.networkmanager.ensureProfiles = {
    environmentFiles = [
      config.sops.secrets."keys/wireguard".path
    ];
    profiles = {
      vpn-tower = {
        connection = {
          autoconnect = "false";
          id = "vpn-tower";
          interface-name = "vpn-tower";
          type = "wireguard";
        };
        ipv4 = {
          address1 = "10.100.0.3/24";
          dns = "8.8.8.8;";
          dns-search = "~;";
          method = "manual";
        };
        ipv6 = {
          addr-gen-mode = "stable-privacy";
          method = "disabled";
        };
        proxy = {};
        wireguard = {
          listen-port = "51820";
          private-key = "$WIREGUARD";
        };
        "wireguard-peer.J8RWzc/LCDUlWbVqnhjrVjWZLUtWmzCMp50gV9VwUms=" = {
          allowed-ips = "0.0.0.0/0;";
          endpoint = "access.gaiasystems.pt:51820";
        };
      };
    };
  };
}
