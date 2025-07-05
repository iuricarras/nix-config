{
  config,
  lib,
  pkgs,
  ...
}: {
  services.sonarr = {
    enable = true;
    user = "streaming";
    group = "streaming";
    openFirewall = true;
  };
  nixpkgs.config.permittedInsecurePackages = [
    "dotnet-sdk-6.0.428"
    "aspnetcore-runtime-6.0.36"
  ];
}
