{ config, lib, pkgs, ... }:

{
    imports =
    [
        ./pterodactyl.nix
        ./cockpit.nix
        ./deluge.nix
        ./memoryGame.nix
        ./memoryGameAPI.nix
        ./memoryGameWS.nix
        ./arr.nix
        ./overseerr.nix
        ./homarr.nix
    ];

}
