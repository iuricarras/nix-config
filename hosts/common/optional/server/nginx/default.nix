{ config, lib, pkgs, ... }:

{
    imports =
    [
        ./hephaestus.nix
        ./hades.nix
        ./demeter.nix
        ./memoryGame.nix
        ./memoryGameAPI.nix
        ./memoryGameWS.nix
        ./poseidon.nix
        ./artemis.nix
        ./gaiaserver.nix
        ./ssi.nix
        ./aether.nix
    ];

}
