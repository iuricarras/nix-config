{
  pkgs,
  lib,
  config,
  self,
  ...
}: let
  discordBot = pkgs.python312Packages.buildPythonApplication {
    pname = "discordBot";
    version = "0.1.0";

    propagatedBuildInputs = with pkgs.python312Packages; [
      discordpy
      aiohttp
      unidecode
      yt-dlp
      pyradios
      python-dotenv
      
    ];
    checkInputs = with pkgs.python312Packages; [
      discordpy
      aiohttp
      unidecode
      yt-dlp
      pyradios
      python-dotenv
    ];
    nativeBuildInputs = [ pkgs.python312Packages.setuptools pkgs.python312Packages.pip ];

    buildInputs = [
      pkgs.python312Packages.setuptools
    ];

    src = pkgs.fetchFromGitHub {
      owner = "iuricarras";
      repo = "discord_bot";
      rev = "9ab1f1adeeffec94746ee20ce604ff817f51575a";
      #sha256 = lib.fakeSha256;
      sha256 = "sha256-tgI++nVRhwiOvM+csXpLHHz/FjnQmdtR7+D4nYvoVIw=";
    };
  };
in {
  systemd.services.discordbot = let 
    python = pkgs.python312.withPackages(ppkgs: with ppkgs; [
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
      ExecStart = "${python}/bin/python ${discordBot}/lib/python3.12/site-packages/discordBot/main.py";
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
