{
  pkgs,
  lib,
  config,
  self,
  inputs,
  ...
}: let
  discordBot = inputs.discord_bot.packages.x86_64-linux.discordBot;
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
