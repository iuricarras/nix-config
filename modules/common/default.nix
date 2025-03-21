# Add common modules to this directory, on their own file (https://wiki.nixos.org/wiki/NixOS_modules).
# These are modules not specific to either nixos or home-manger.

{ lib, ... }:
{
  imports = lib.custom.scanPaths ./.;
}