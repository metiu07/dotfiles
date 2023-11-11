{ config, pkgs, ... }:
{
  imports =
    [
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Set the kernel
  boot.kernelPackages = pkgs.linuxPackages_zen;

  # Driver for the USB WiFi dongle
  boot.extraModulePackages = with config.boot.kernelPackages; [ 
    rtl8821au 
  ];
  boot.initrd.kernelModules = [ 
    "8821au" 
  ];

  # Setup keyfile
  boot.initrd.secrets = {
    "/crypto_keyfile.bin" = null;
  };

  networking.hostName = "nixos";

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
    layout = "us";
    xkbVariant = "colemak_dh";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;

  # Syncthing
  services = {
    syncthing = {
        enable = true;
        user = "anon";
        dataDir = "/home/anon/Documents";    # Default folder for new synced folders
        configDir = "/home/anon/Documents/.config/syncthing";   # Folder for Syncthing's settings and keys
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

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.anon = {
    isNormalUser = true;
    description = "Anon";
    extraGroups = [ "networkmanager" "wheel" "video" ];
    packages = with pkgs; [
      alacritty
      anki-bin
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
      python311Packages.black
      python311Packages.ipdb
      python311Packages.ipython
      python311Packages.isort
      tor-browser-bundle-bin
      vscodium
      wdisplays
      wireshark
      wl-clipboard
      wofi
      xfce.thunar
      youtube-dl
    ];
    shell = pkgs.fish;
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Fonts
  fonts.fonts = with pkgs; [
    liberation_ttf
    nerdfonts
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

  # Brightness control
  programs.light.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Swap
  swapDevices = [ {
    device = "/var/lib/swapfile";
    size = 4*1024;
  } ];

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
    cmake
    curl
    docker-compose
    entr
    exa
    fd
    file
    fishPlugins.fzf-fish
    fwupd
    fzf
    gcc
    gdb
    git
    glib
    gnome3.adwaita-icon-theme
    gnumake
    grim
    htop
    jq
    linuxHeaders
    lshw
    lsof
    ltrace
    mako
    ncdu
    neovim
    netcat-gnu
    obs-studio
    openssh
    poetry
    powertop
    pstree
    pyright
    python311Full
    ranger
    ripgrep
    rofi
    rustup
    slurp
    starship
    strace
    swayidle
    swaylock
    tcpdump
    tmux
    torsocks
    traceroute
    tree
    unzip
    upower
    util-linux
    waybar
    wayland
    wget
    xdg-utils
    yq-go
    zip
    zoxide
  ];
}
