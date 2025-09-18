{
  pkgs,
  lib,
  config,
  self,
  ...
}: let
  discordBot = pkgs.python313Packages.buildPythonApplication {
    pname = "discordBot";
    version = "0.1.1";
    pyproject = true;
    build-system = [pkgs.python313Packages.setuptools];
    propagatedBuildInputs = with pkgs.python313Packages; [
      discordpy
      aiohttp
      unidecode
      yt-dlp
      pyradios
      python-dotenv
      
    ];
    checkInputs = with pkgs.python313Packages; [
      discordpy
      aiohttp
      unidecode
      yt-dlp
      pyradios
      python-dotenv
    ];
    nativeBuildInputs = [ pkgs.python313Packages.setuptools pkgs.python313Packages.pip ];

    buildInputs = [
      pkgs.python313Packages.setuptools
    ];

    src = pkgs.fetchFromGitHub {
      owner = "iuricarras";
      repo = "discord_bot";
      rev = "bc17f490f1e3315d2ef7db5b64b33feed444b006";
      #sha256 = lib.fakeSha256;
      sha256 = "sha256-WyPIVPDcyZAlbq20fhRwZ1Zia8H2dMJBGHNUWfyuQ4A=";
    };
  };
in {
  systemd.services.discordbot = let 
    python = pkgs.python313.withPackages(ppkgs: with ppkgs; [
      discordpy
      aiohttp
      unidecode
      yt-dlp
      pyradios
      python-dotenv
    ]);
  in {
    wantedBy = ["multi-user.target"];
    after = ["network.target"];
    description = "Bot Discord";
    environment = {
      DISCORD_TOKEN_PATH = "${config.sops.secrets."discord-token".path}";
    };
    serviceConfig = {
      User = "discord";
      Group = "discord";
      Restart = "always";
      ExecStart = "${python}/bin/python ${discordBot}/lib/python3.13/site-packages/discordBot/main.py";
      StartLimitBurst = "30";
      RestartSec = "5s";
    };
  };

  environment.systemPackages = with pkgs; [
    discordBot
    python312
  ];

  users.users."discord" = {
    isSystemUser = true;
    group = "discord";
  };

  users.groups.discord.members = ["discord"];
}
