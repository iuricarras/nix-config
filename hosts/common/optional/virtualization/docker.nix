{config, ...}:
let
  user = config.hostSpec.username;
in
{
  virtualisation.docker.enable = true;
  users.users.${user}.extraGroups = [ "docker" ];
}