{
  ...
}: {
  virtualisation.oci-containers = {
    backend = "docker";
    containers = {
      windows = {
        autoStart = false;  
        image = "dockurr/windows";
        ports = [
          "8006:8006"
          "3389:3389/tcp"
          "3389:3389/udp"
        ];
        capabilities = {NET_ADMIN = true;};
        volumes = [
          "/var/docker/homarr/appdata:/appdata"
          "/home/iuricarras/.vmdisks/docker/windows:/storage"
          "/home/iuricarras:/shared"
        ];
        environment = {
          CPU_CORES = "2";
          VERSION = "10";
        };
        devices = [
          "/dev/kvm"
        "/dev/net/tun"
        ]
        ;
      };
    };
  };
}
