{inputs, config, ...}:
let
  secretspath = builtins.toString inputs.mysecrets;
in
{

  imports = [
    inputs.sops-nix.nixosModules.sops
  ];

  sops = {
    defaultSopsFile = "${secretspath}/secret.yaml";
    validateSopsFiles = false;

    age ={
      sshKeyPaths = [
        "/etc/ssh/ssh_host_ed25519_key"
      ];
      keyFile = "/var/lib/sops-nix/key.txt";
      generateKey = true;
    };

    secrets = {
      discord-token = {};
      homarr-api-token = {};
      cloudflare-api = {};
    };
  };
}