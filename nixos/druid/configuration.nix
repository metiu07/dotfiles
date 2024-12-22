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
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      max-jobs = 4;
    };
  };

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Set the kernel
  # boot.kernelPackages = pkgs.linuxPackages_zen;
  # boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelPackages = pkgs.linuxPackages_6_6;
  # boot.kernelPackages = pkgs.linuxPackages;

  # Enable aarch64 cross compilation
  # boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

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

  # environment.variables = {
  #   XDG_SESSION_TYPE = "wayland";
  #   XDG_CURRENT_DESKTOP = "sway";
  # };

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
  services.xserver = {
    xkb = {
      layout = "us,sk";
      variant = "colemak_dh,qwerty";
      options = "caps:escape,altwin:swap_lalt_lwin";
    };
  };

  # Enable CUPS to print documents.
  # services.printing.enable = true;

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

  # programs.gnupg.agent = {
  #   enable = true;
  # };

  # Wireshark
  programs.wireshark.enable = true;

  # OpenSSH
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users = {
    anon = {
      isNormalUser = true;
      description = "Anon";
      extraGroups = [ "networkmanager" "wheel" "video" "libvirtd" "wireshark" ];
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHK2Aomah/vuuA7Xkb3WYQIoMcwEk2hbu2VEh30DmIdH paladin"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJvltRXYpfWZnU1GdBM4hAQOoKuUWgo5yhdM/6MVUYzP hunter"
      ];
      packages = with pkgs; [
        alacritty
        anki # prefer this over anki-bin which seems to be more demanding for the build (time + resources)
        bat
        brave
        calibre
        chromium
        evince
        exiftool
        firefox
        gimp
        gpxsee
        hyperfine
        inkscape-with-extensions
        keepassxc
        libreoffice-fresh
        lua-language-server
        mpv
        networkmanagerapplet
        pandoc
        poetry
        python311Packages.black
        python311Packages.ipdb
        python311Packages.ipython
        python311Packages.isort
        python311Packages.yt-dlp
        qalculate-gtk
        ruff-lsp
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
        # obs-studio
        # steam
        alacritty
        brave
        firefox
        mpv
        networkmanagerapplet
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
    # nerdfonts
    (nerdfonts.override {
      fonts = [
        "InconsolataLGC"
        "Iosevka"
        "UbuntuMono"
        "VictorMono"
      ];
    })
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
    size = 8 * 1024;
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
    aria2
    btop
    btrfs-progs
    ccrypt
    cmake
    curl
    ddcutil
    delta
    dmidecode
    docker-compose
    dosfstools
    entr
    evince
    exfatprogs
    eza
    fastfetch
    fatresize
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
    gsettings-desktop-schemas
    gtk3
    gtk4
    htop
    hwinfo
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
    nethogs
    nil
    nix-tree
    nixpkgs-fmt
    nmap
    nodePackages.prettier
    nodejs_22
    nomacs
    openssh
    parted
    pciutils
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
    starship
    strace
    swappy
    sway-contrib.grimshot
    swayidle
    swaylock
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
    wget
    xdg-utils
    yq-go
    zathura
    zip
    zoxide
    zstd
  ];
}
