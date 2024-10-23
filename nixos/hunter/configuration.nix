{ config, pkgs, ... }:
{
  imports =
    [
      ./hardware-configuration.nix
    ];

  # Nix configuration
  nix = {
    # package = pkgs.nixFlakes;
    # extraOptions = ''
    #   experimental-features = nix-command flakes
    # '';
    gc.automatic = true;
    # nix.gc.options = "--delete-older-than 10d"
    settings.experimental-features = [ "nix-command" "flakes" ];
  };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Set the kernel
  # boot.kernelPackages = pkgs.linuxPackages_zen;
  # boot.kernelPackages = pkgs.linuxPackages_latest;
  # boot.kernelPackages = pkgs.linuxPackages_6_1;
  boot.kernelPackages = pkgs.linuxPackages;

  # Polkit
  security.polkit.enable = true;

  # Sudo
  security.sudo = {
    enable = true;
    # extraRules = [{
    #   commands = [
    #     {
    #       command = "${pkgs.ddcutil}/bin/ddcutil setvcp 60 0x11";
    #       options = [ "NOPASSWD" ];
    #     }
    #   ];
    #   groups = [ "wheel" ];
    # }];
  };

  # Driver for the USB WiFi dongle
  boot.extraModulePackages = with config.boot.kernelPackages; [
    rtl8821au
  ];
  boot.initrd.kernelModules = [
    "8821au"
    "i2c-dev"
  ];

  # Setup keyfile
  # boot.initrd.secrets = {
  #   "/crypto_keyfile.bin" = null;
  # };

  networking.hostName = "hunter";
  # networking.hostId = "98921cba";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Bratislava";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # environment.variables = {
  #   XDG_SESSION_TYPE = "wayland";
  #   XDG_CURRENT_DESKTOP = "sway";
  # };

  # Needed for the foot terminal color themes
  environment.pathsToLink = [ "/share/foot" ];

  services.xserver = {
    enable = true;
    displayManager.gdm.enable = true;
    # desktopManager.gnome.enable = true;
    # desktopManager.plasma5.enable = true;
    desktopManager.xfce.enable = true;
  };

  # Enable sway window manager
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    extraSessionCommands = ''
      export SDL_VIDEODRIVER=wayland
      # I had this originally
      # export QT_QPA_PLATFORM=wayland
      export QT_QPA_PLATFORM=wayland-egl
      export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
      export _JAVA_AWT_WM_NONREPARENTING=1
      export SUDO_ASKPASS="${pkgs.ksshaskpass}/bin/ksshaskpass"
      export SSH_ASKPASS="${pkgs.ksshaskpass}/bin/ksshaskpass"
      export XDG_SESSION_TYPE=wayland
      export XDG_CURRENT_DESKTOP=sway
    '';
  };


  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us,sk";
    variant = "colemak_dh,qwerty";
    options = "caps:escape,altwin:swap_lalt_lwin";
  };

  # Syncthing
  services = {
    syncthing = {
      enable = true;
      user = "anon";
      dataDir = "/home/anon/Documents"; # Default folder for new synced folders
      configDir = "/home/anon/Documents/.config/syncthing"; # Folder for Syncthing's settings and keys
    };

    # TailScale
    tailscale = {
      enable = true;
    };

    # Power Profiles Daemon -- power management
    power-profiles-daemon = {
      enable = true;
    };
  };

  # Pipewire
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };

  # Bluetooth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true;
  # hardware.pulseaudio.enable = true;

  # Docker
  virtualisation.docker.enable = true;

  # Libvirt
  virtualisation.libvirtd.enable = true;
  programs.dconf.enable = true; # virt-manager requires dconf to remember settings

  # programs.gnupg.agent = {
  #   enable = true;
  # };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users = {
    anon = {
      isNormalUser = true;
      description = "Anon";
      extraGroups = [ "networkmanager" "wheel" "video" "libvirtd" ];
      packages = with pkgs; [
        alacritty
        anki-bin
        bat
        brave
        calibre
        chromium
        copyq
        evince
        exiftool
        firefox
        gimp
        gnome.eog
        gnome.file-roller
        gpxsee
        hyperfine
        inkscape-with-extensions
        keepassxc
        libreoffice-fresh
        lua-language-server
        mpv
        networkmanagerapplet
        pandoc
        python311Packages.black
        python311Packages.ipdb
        python311Packages.ipython
        python311Packages.isort
        python311Packages.yt-dlp
        qalculate-gtk
        tor-browser-bundle-bin
        vlc
        vscodium
        wdisplays
        wireshark
        wl-clipboard
        wofi
        xarchiver
        xfce.mousepad
        xfce.ristretto
        xfce.thunar
        xfce.thunar-archive-plugin
        xfce.thunar-volman
      ];
      shell = pkgs.fish;
    };
    gamey = {
      isNormalUser = true;
      description = "Gamey";
      extraGroups = [ "networkmanager" "video" ];
      packages = with pkgs; [
        alacritty
        brave
        firefox
        mpv
        networkmanagerapplet
        obs-studio
        steam
        tor-browser-bundle-bin
        vscodium
        wl-clipboard
        wofi
        xfce.thunar
      ];
      shell = pkgs.fish;
    };
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Fonts
  fonts.packages = with pkgs; [
    liberation_ttf
    nerdfonts
    # (nerdfonts.override { fonts = [
    #     "Anonymice"
    #     "DroidSansMono"
    #     "FiraCode"
    #     "InconsolataLGC"
    #     "Iosevka"
    #     "IosevkaTerm"
    #     "JetBrainsMono"
    #     "TerminessTTF"
    #     "UbuntuMono"
    #     "VictorMono"
    #     "VictorMono"
    #     "agave"
    # ]; })
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
  ];

  # Fish
  programs.fish.enable = true;

  # XDG desktop portal
  services.dbus.enable = true;
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = with pkgs; [
      # xdg-desktop-portal-wlr
      xdg-desktop-portal-kde
      # gtk portal needed to make gtk apps happy
      # xdg-desktop-portal-gtk (disabled as it causes errors)
    ];
  };

  # Tor
  services.tor = {
    enable = true;
    client.enable = true;
  };

  # Default applications
  xdg.mime.defaultApplications = {
    "application/pdf" = "evince.desktop";
  };

  # Brightness control
  programs.light.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Swap
  swapDevices = [{
    device = "/var/lib/swapfile";
    size = 4 * 1024;
  }];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

  # Packages
  environment.systemPackages = with pkgs; [
    # Causes rebuild to fail because it depends on vulnerable version of nix?
    # nixd
    # pinentry
    alacritty
    android-file-transfer
    bandwhich
    blueman
    btop
    btrfs-progs
    ccrypt
    cmake
    curl
    ddcutil
    delta
    docker-compose
    dosfstools
    entr
    evince
    exfat
    eza
    fastfetch
    fatresize
    fd
    ffmpeg
    file
    foot
    fwupd
    fzf
    gcc
    gdb
    git
    glances
    glib
    gnome.adwaita-icon-theme
    gnumake
    gpa
    gparted
    grim
    gtk3
    gtk4
    htop
    hwinfo
    iftop
    imagemagick
    imhex
    imv
    ioping
    jq
    kanshi
    libheif
    libnotify
    libqalculate
    linuxHeaders
    lm_sensors
    lshw
    lsof
    ltrace
    lxqt.lxqt-policykit
    mako
    meld
    mosh
    ncdu
    neovim
    netcat-gnu
    nil
    nix-tree
    nixpkgs-fmt
    nmap
    nodePackages.prettier
    nodejs_22
    ntfs3g
    openssh
    parted
    pciutils
    poetry
    powertop
    psmisc
    pulseaudio
    pyright
    python311Full
    qrencode
    ranger
    ripgrep
    rofi
    rustup
    slurp
    smartmontools
    starship
    strace
    swappy
    sway-contrib.grimshot
    swayidle
    swaylock
    sysstat
    tcpdump
    tmux
    torsocks
    traceroute
    tree
    unixtools.fdisk
    unixtools.xxd
    unzip
    upower
    usbutils
    util-linux
    virt-manager
    vscode
    waybar
    wayland
    wezterm
    wget
    xdg-user-dirs
    xdg-utils
    yazi
    yq-go
    zathura
    zip
    zoxide
    zstd
  ];
}
