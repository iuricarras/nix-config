{...}: {
  services.jellyfin = {
    enable = true;
    openFirewall = true;
    group = "streaming";
  };

  users.groups.streaming.members = ["streaming"];
}
