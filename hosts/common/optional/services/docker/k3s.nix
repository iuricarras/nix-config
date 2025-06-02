{...}: {
  virtualisation.oci-containers = {
    backend = "docker";
    containers = {
      k3s-server-1 = {
        autoStart = true;
        image = "rancher/k3s:v1.32.4-k3s1";
        ports = [
          "6443:6443"
          "8001:8001"
        ];
        capabilities = {NET_ADMIN = true;};
        volumes = [
          "k3s-server:/var/lib/rancher/k3s"
          ".:/output"
        ];
        environment = {
          K3S_TOKEN = "01A6gCqY/a2EyBE6tPJqHLbaDsylxaufxa/nE7TUYck=";
          K3S_KUBECONFIG_OUTPUT = "/output/kubeconfig.yaml";
          K3S_KUBECONFIG_MODE = "666";
        };
        privileged = true;
        cmd = ["server"];
        networks = ["k3s-network"];
      };
      k3s-worker-1 = {
        autoStart = true;
        image = "rancher/k3s:v1.32.4-k3s1";
        capabilities = {NET_ADMIN = true;};
        volumes = [
          "k3s-worker-1:/var/lib/rancher/k3s"
        ];
        environment = {
          K3S_TOKEN = "01A6gCqY/a2EyBE6tPJqHLbaDsylxaufxa/nE7TUYck=";
          K3S_URL = "https://k3s-server-1:6443";
        };
        privileged = true;
                networks = ["k3s-network"];
      };
      k3s-worker-2 = {
        autoStart = true;
        image = "rancher/k3s:v1.32.4-k3s1";
        capabilities = {NET_ADMIN = true;};
        volumes = [
          "k3s-worker-2:/var/lib/rancher/k3s"
        ];
        environment = {
          K3S_TOKEN = "01A6gCqY/a2EyBE6tPJqHLbaDsylxaufxa/nE7TUYck=";
          K3S_URL = "https://k3s-server-1:6443";
        };
        privileged = true;
                networks = ["k3s-network"];
      };
    };
  };
}
