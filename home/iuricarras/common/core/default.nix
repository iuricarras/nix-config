{
  config,
  lib,
  pkgs,
  hostSpec,
  ...
}: {
  imports = lib.flatten [
    (map lib.custom.relativeToRoot [
      "modules/common/host-spec.nix"
      "modules/home"
    ])
    ./bash.nix
    ./bat.nix
    #./ssh.nix
  ];

  inherit hostSpec;

  services.ssh-agent.enable = true;

  home = {
    username = lib.mkDefault config.hostSpec.username;
    homeDirectory = lib.mkDefault config.hostSpec.home;
    stateVersion = lib.mkDefault "23.05";
    sessionPath = [
      "$HOME/.local/bin"
    ];
    sessionVariables = {
      NH_FLAKE = "$HOME/Github/nix-config";
      MANPAGER = "batman"; # see ./cli/bat.nix
      NIXOS_OZONE_WL = "1";
    };
    preferXdgDirectories = true; # whether to make programs use XDG directories whenever supported
  };
  #TODO(xdg): maybe move this to its own xdg.nix?
  # xdg packages are pulled in below
  xdg = {
    enable = true;
    userDirs = {
      enable = true;
      createDirectories = true;
      desktop = "${config.home.homeDirectory}/Desktop";
      documents = "${config.home.homeDirectory}/Documents";
      download = "${config.home.homeDirectory}/Downloads";
      music = "${config.home.homeDirectory}/Music";
      pictures = "${config.home.homeDirectory}/Pictures";
      videos = "${config.home.homeDirectory}/Videos";
      # publicshare = "/var/empty"; #using this option with null or "/var/empty" barfs so it is set properly in extraConfig below
      # templates = "/var/empty"; #using this option with null or "/var/empty" barfs so it is set properly in extraConfig below

      extraConfig = {
        # publicshare and templates defined as null here instead of as options because
        XDG_PUBLICSHARE_DIR = "/var/empty";
        XDG_TEMPLATES_DIR = "${config.home.homeDirectory}/Templates";
      };
    };
  };

  home.packages = builtins.attrValues {
    inherit
      (pkgs)
      # Packages that don't have custom configs go here
      btop # resource monitor
      coreutils # basic gnu utils
      curl
      discord # chat
      nextcloud-client # cloud sync
      tldr
      nixd
      alejandra
      wget
      nil
      hugo
      findutils # find
      neofetch # fancier system info than pfetch
      p7zip # compression & encryption
      steam-run # for running non-NixOS-packaged binaries on Nix
      tree # cli dir tree viewer
      unzip # zip extraction
      unrar # rar extractio
      xdg-utils # provide cli tools such as `xdg-mime` and `xdg-open`
      xdg-user-dirs
      yq-go # yaml pretty printer and manipulator
      zip # zip compression
      git
      neovim
      ;
  };
  
  nix = {
    package = lib.mkDefault pkgs.nix;
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      warn-dirty = false;
    };
  };

  programs.home-manager.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";
}
