{config, ...}:{
  programs.ssh = {
    enable = true;
    matchBlocks = {
      "github" = {
        host = "github.com";
        identitiesOnly = true;
        identityFile = "${config.home.homeDirectory}/.ssh/id_git";
      };
      "gaia" = {
        host = "gaia";
        hostname = "192.168.14.11";
        user = "gaia";
        identitiesOnly = true;
        identityFile = "${config.home.homeDirectory}/.ssh/id_${config.hostSpec.hostName}";
      };
    };
  };
}