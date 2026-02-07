{config, ...}: {
  services.syncthing = {
    enable = true;
    guiPasswordFile = "${config.sops.secrets."aether-password".path}";
    openDefaultPorts = true;
    settings.gui = {
      user = "gaia";
    };
  };
}
