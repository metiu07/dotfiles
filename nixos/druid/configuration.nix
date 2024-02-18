{ config, pkgs, ... }:
{
  imports =
    [
      ./hardware-configuration.nix
    ];

  # Nix configuration
  nix.gc.automatic = true;
  # nix.gc.options = "--delete-older-than 10d"

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Set the kernel
  boot.kernelPackages = pkgs.linuxPackages_zen;
  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.forceImportRoot = false;

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
  boot.initrd.secrets = {
    "/crypto_keyfile.bin" = null;
  };

  networking.hostName = "druid";
  networking.hostId = "98921cba";

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

  environment.variables = {
    XDG_SESSION_TYPE = "wayland";
    XDG_CURRENT_DESKTOP = "sway";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Display Manager
  services.xserver.displayManager.gdm.enable = true;

  # Configure keymap in X11
  services.xserver = {
    layout = "us,sk";
    xkbVariant = "colemak_dh,qwerty";
    xkbOptions = "caps:escape,altwin:swap_lalt_lwin";
  };

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;

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
  };

  # Pipewire
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;
    wireplumber.enable = true;
  };

  # Docker
  virtualisation.docker.enable = true;

  # Libvirt
  virtualisation.libvirtd.enable = true;
  programs.dconf.enable = true; # virt-manager requires dconf to remember settings

  programs.gnupg.agent = {
    enable = true;
    pinentryFlavor = "qt";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users = {
    anon = {
      isNormalUser = true;
      description = "Anon";
      extraGroups = [ "networkmanager" "wheel" "video" "libvirtd" ];
      packages = with pkgs; [
        # anki-bin
        alacritty
        bat
        brave
        calibre
        firefox
        gimp
        hyperfine
        keepassxc
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
        vscodium
        wdisplays
        wireshark
        wl-clipboard
        wofi
        xarchiver
        xfce.mousepad
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
    # gtk portal needed to make gtk apps happy
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  # Tor
  services.tor = {
    enable = true;
    client.enable = true;
  };

  # enable sway window manager
  programs.sway = {
    enable = true;
    wrapperFeatures = {
      base = true;
      gtk = true;
    };
    extraSessionCommands = ''
      export SDL_VIDEODRIVER=wayland
      export QT_QPA_PLATFORM=wayland
      export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
      export _JAVA_AWT_WM_NONREPARENTING=1
      export SUDO_ASKPASS="${pkgs.ksshaskpass}/bin/ksshaskpass"
      export SSH_ASKPASS="${pkgs.ksshaskpass}/bin/ksshaskpass"
      export XDG_SESSION_TYPE=wayland
      export XDG_CURRENT_DESKTOP=sway
    '';
  };

  # enable DE
  # services.xserver.desktopManager.gnome.enable = true;
  # services.xserver.desktopManager.plasma5.enable = true;
  services.xserver.desktopManager.xfce.enable = true;

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
    alacritty
    android-file-transfer
    btop
    btrfs-progs
    cmake
    curl
    ddcutil
    delta
    docker-compose
    entr
    evince
    exfatprogs
    eza
    fd
    ffmpeg
    file
    fwupd
    fzf
    gcc
    gdb
    git
    glances
    glib
    gnome3.adwaita-icon-theme
    gnumake
    gpa
    gparted
    grim
    htop
    imagemagick
    imhex
    imv
    jq
    kanshi
    libnotify
    libqalculate
    linuxHeaders
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
    nixd
    nixpkgs-fmt
    nmap
    nodePackages.prettier
    nodejs_21
    openssh
    parted
    pciutils
    pinentry
    poetry
    powertop
    psmisc
    pyright
    python311Full
    qrencode
    ranger
    ripgrep
    rofi
    rustup
    slurp
    speechd
    starship
    strace
    swappy
    sway-contrib.grimshot
    swayidle
    swaylock
    tcpdump
    tmux
    torsocks
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
    waybar
    wayland
    wget
    xdg-utils
    yq-go
    zathura
    zfs
    zip
    zoxide
    zstd
  ];
}
