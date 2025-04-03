{config,...}:
let
  username = config.hostSpec.username;
in 
{
  virtualisation.virtualbox.host.enable = true;
  users.extraGroups.vboxusers.members = [ "${username}" ];
}