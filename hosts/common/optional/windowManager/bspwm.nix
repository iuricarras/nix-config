{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    bspwm
    feh
    sxhkd
    xsettingsd
    dunst
    light
    picom
    polybarFull
    pulsemixer
    rofi
    xfce.xfce4-power-manager
    mate.atril
    galculator
    geany
    mplayer
    xfce.thunar
    xfce.thunar-archive-plugin
    xfce.thunar-media-tags-plugin
    xfce.thunar-volman
    viewnior
    htop
    ncdu
    nethogs
    ranger
    vim
    zsh
    acpi
    blueman
    ffmpegthumbnailer
    noto-fonts
    highlight
    inotify-tools
    iw
    jq
    libwebp
    libavif
    libheif
    maim
    meld
    mpc-cli
    mpd
    ncmpcpp
    neofetch
    pavucontrol
    powertop
    libsForQt5.qt5ct
    libsForQt5.qtstyleplugin-kvantum
    simplescreenrecorder
    trash-cli
    xfce.tumbler
    wmctrl
    wmname
    xclip
    xdg-user-dirs
    xdotool
    yad
    bzip2
    gzip
    lrzip
    lz4
    lzip
    lzop
    p7zip
    rar
    gnutar
    unzip
    unrar
    xarchiver
    zip
    zstd
    libnma
    pywal
    ueberzug
    betterlockscreen
    alacritty
    networkmanager_dmenu
    dmenu
    pastel
    mate.mate-polkit
    ksuperkey
    killall
    lxappearance
    xorg.xbacklight
    sddm-chili-theme
    redshift
    libsForQt5.networkmanager-qt
    python312Packages.pygobject3
    python312Packages.gst-python
    python312Packages.pycairo
    networkmanagerapplet
    sound-theme-freedesktop
  ];

  services = {
    xserver.windowManager.bspwm.enable = true;
    displayManager.sddm.enable = true;
    displayManager.sddm.theme = "${import ./archcraft.nix {inherit pkgs;}}";
    displayManager.sddm.autoNumlock = true;
    gvfs.enable = true;
    gnome.gnome-keyring.enable = true;
  };

  xdg.portal = {
    enable = true;
    extraPortals = [pkgs.xdg-desktop-portal-gtk];
    config.common.default = "*";
  };

  security.polkit.enable = true;
  security.pam.services.sddm.enableGnomeKeyring = true;
  programs.ssh.startAgent = true;
  programs.seahorse.enable = true;
  services.xserver.displayManager.setupCommands = ''
    eval $(/run/wrappers/bin/gnome-keyring-daemon --start --daemonize)
    export SSH_AUTH_SOCK
  '';

  # services.udev.extraRules = lib.mkIf cfg.laptop ''
  # 	ACTION=="add", SUBSYSTEM=="backlight", KERNEL=="intel_backlight", MODE="0666", RUN+="${pkgs.coreutils}/bin/chmod a+w /sys/class/backlight/%k/brightness"
  # '';
}
