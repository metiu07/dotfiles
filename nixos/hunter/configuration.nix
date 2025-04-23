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
  boot.kernelPackages = pkgs.linuxPackages_zen;
  # boot.kernelPackages = pkgs.linuxPackages_latest;
  # boot.kernelPackages = pkgs.linuxPackages_6_1;
  # boot.kernelPackages = pkgs.linuxPackages;

  # Brightness control for external monitors
  boot.kernelModules = [ "i2c_dev" ];

  # Enable aarch64 cross compilation (useful when building RPI SD image)
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  # Polkit
  security.polkit.enable = true;

  # Sudo
  security.sudo = {
    enable = true;
  };

  # Setup keyfile
  # boot.initrd.secrets = {
  #   "/crypto_keyfile.bin" = null;
  # };

  networking = {
    hostName = "hunter";
    # hostId = "98921cba";

    # Enable networking
    networkmanager.enable = true;

    # Firewall configuration
    firewall = {
      enable = true;
      trustedInterfaces = [ "tailscale0" ];
      checkReversePath = "loose";
    };
  };

  # Configure DNS
  # networking.nameservers = [ "194.242.2.4#base.dns.mullvad.net" ];
  # networking.nameservers = [ "194.242.2.9#all.dns.mullvad.net" ];
  networking.nameservers = [ "194.242.2.6#family.dns.mullvad.net" ];
  services.resolved = {
    enable = true;
    # dnssec = "true";
    domains = [ "~." ];
    fallbackDns = [ "1.1.1.1#one.one.one.one" "1.0.0.1#one.one.one.one" ];
    dnsovertls = "true";
  };

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
    LC_TIME = "en_GB.UTF-8";
  };

  environment.variables = {
    XDG_SESSION_TYPE = "wayland";
    XDG_CURRENT_DESKTOP = "sway";
  };

  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "iHD";
  };

  services.xserver = {
    enable = true;
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
    desktopManager.xfce.enable = true;
    # desktopManager.plasma5.enable = true;
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

    openssh = {
      enable = false;
      settings = {
        PermitRootLogin = "no";
        PasswordAuthentication = false;
      };
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

  # I2C (for setting brightness of external monitors)
  hardware.i2c.enable = true;

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      # ... your Open GL, Vulkan and VAAPI drivers
      # vpl-gpu-rt # or intel-media-sdk for QSV
      intel-media-driver
      intel-media-sdk
    ];
  };

  # Virtualisation
  virtualisation = {
    # Docker
    docker.enable = true;

    # Podman
    podman.enable = true;
  };

  # Libvirt
  programs.dconf.enable = true; # virt-manager requires dconf to remember settings
  programs.virt-manager.enable = true;
  users.groups.libvirtd.members = [ "anon" ];
  virtualisation.libvirtd.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;
  # virtualisation.tpm.enable = true;
  virtualisation.libvirtd.qemu.swtpm.enable = true;

  programs.gnupg.agent = {
    enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users = {
    anon = {
      isNormalUser = true;
      description = "Anon";
      extraGroups = [ "networkmanager" "wheel" "video" "libvirtd" "wireshark" "kvm" ];
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJYzvgOCLQsGGaw0J38r1Vdw/8nARKaWtVjU3lZ4DGXP mage"
      ];
      packages = with pkgs; [
        alacritty
        anki-bin
        bat
        blueman
        borgbackup
        brave
        calibre
        chromium
        copyq
        eog
        evince
        exiftool
        file-roller
        firefox
        gimp
        gpxsee
        grim
        hexyl
        hyperfine
        imhex
        inkscape-with-extensions
        keepassxc
        libreoffice-still
        librewolf-bin
        lua-language-server
        mpv
        networkmanagerapplet
        nil
        nodePackages.prettier
        nodePackages.typescript-language-server
        nodejs_22
        pandoc
        pkg-config
        poetry
        pyright
        python312Packages.black
        python312Packages.ipdb
        python312Packages.ipython
        python312Packages.isort
        python312Packages.pipx
        qalculate-gtk
        qrencode
        quickemu
        ranger
        restic
        ripgrep
        rofi
        ruff
        ruff-lsp
        rustup
        slurp
        sushi
        swappy
        sway-contrib.grimshot
        swayidle
        tor-browser-bundle-bin
        translate-shell
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
        xournalpp
        yarn
        zathura
        zoxide
      ];
      shell = pkgs.fish;
    };
    # gamey = {
    #   isNormalUser = true;
    #   description = "Gamey";
    #   extraGroups = [ "networkmanager" "video" ];
    #   packages = with pkgs; [
    #     alacritty
    #     brave
    #     firefox
    #     mpv
    #     networkmanagerapplet
    #     obs-studio
    #     steam
    #     tor-browser-bundle-bin
    #     vscodium
    #     wl-clipboard
    #     wofi
    #     xfce.thunar
    #   ];
    #   shell = pkgs.fish;
    # };
  };

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
    noto-fonts-cjk-sans
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

  # Documentation
  documentation.dev.enable = true;

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
    adwaita-icon-theme
    android-file-transfer
    aria2
    bandwhich
    bc
    brightnessctl
    btop
    btrfs-progs
    ccrypt
    cmake
    curl
    ddcutil
    delta
    dnsutils
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
    gammastep
    gcc
    gdb
    git
    glances
    glib
    gnumake
    gnupg
    gpa
    gparted
    gtk3
    gtk4
    hdparm
    htop
    httpie
    hwinfo
    iftop
    imagemagick
    imhex
    imv
    iw
    jless
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
    man-pages
    man-pages-posix
    meld
    mosh
    ncdu
    neovim
    netcat-gnu
    nixpkgs-fmt
    nmap
    ntfs3g
    nvtopPackages.intel
    openssh
    parallel
    parted
    pciutils
    powertop
    psmisc
    pulseaudio
    pv
    python312Full
    smartmontools
    starship
    strace
    swaylock
    swtpm
    tcpdump
    tmux
    torsocks
    traceroute
    unixtools.fdisk
    unixtools.xxd
    unzip
    upower
    usbutils
    util-linux
    waybar
    wayland
    wezterm
    wget
    xdg-user-dirs
    xdg-utils
    yq-go
    zip
    zstd
  ];
}
