{ config, lib, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    wget
    git
    php83
    php83Extensions.gd
    php83Extensions.pdo_mysql
    php83Extensions.mbstring
    php83Extensions.bcmath
    php83Extensions.xml
    php83Extensions.curl
    php83Extensions.zip
    php83Packages.composer
    nh
    openssl
    nodejs_22
    bun
    alejandra
    nixd
    wireguard-tools
    hugo
    dig
    sops
  ];

  programs = {
    nix-ld.enable = true;
  };
}