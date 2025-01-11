{ pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

  boot.kernelPackages = pkgs.linuxPackages_hardened;

  boot.loader.grub.enable = false;
  boot.loader.generic-extlinux-compatible.enable = true;

  networking.hostName = "mage";
  networking.hostId = "df1a2179";
  networking.networkmanager.enable = true;

  system.autoUpgrade = {
    enable = true;
    dates = "02:00";
    randomizedDelaySec = "45min";
  };

  nix = {
    settings.experimental-features = [ "nix-command" "flakes" ];
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };
  };

  # Firewall
  networking.firewall = {
    enable = true;
    # allowedTCPPorts = [ 2283 ];
  };

  # Docker
  virtualisation.docker.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Bratislava";

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

  programs.fish.enable = true;

  users.users = {
    anon = {
      isNormalUser = true;
      extraGroups = [ "networkmanager" "wheel" ];
      packages = [ ];
      shell = pkgs.fish;
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJvltRXYpfWZnU1GdBM4hAQOoKuUWgo5yhdM/6MVUYzP hunter"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHK2Aomah/vuuA7Xkb3WYQIoMcwEk2hbu2VEh30DmIdH paladin"
      ];
    };

    immich.extraGroups = [ "video" "render" ];
  };

  services = {
    # Syncthing
    syncthing.enable = true;

    # Tailscale
    tailscale = {
      enable = true;
      useRoutingFeatures = "server";
    };

    # Tor
    tor = {
      enable = true;
      client.enable = true;
    };

    # Immich
    immich = {
      enable = true;
      openFirewall = true;
      host = "0.0.0.0";
      machine-learning.enable = false;
    };

    # Workaround for nixos-rebuild switch failure
    # https://discourse.nixos.org/t/logrotate-config-fails-due-to-missing-group-30000/28501
    logrotate.checkConfig = false;
  };

  # Documentation
  documentation.dev.enable = true;

  # Swap
  swapDevices = [{
    device = "/var/lib/swapfile";
    size = 4 * 1024;
  }];

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
  };

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "23.11"; # Did you read the comment?

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    bandwhich
    bat
    btop
    btrfs-progs
    ccrypt
    cmake
    curl
    delta
    docker-compose
    entr
    eza
    fastfetch
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
    gnumake
    htop
    hwinfo
    iftop
    imagemagick
    imhex
    jq
    libqalculate
    libraspberrypi
    linuxHeaders
    lshw
    lsof
    ltrace
    man-pages
    man-pages-posix
    mosh
    ncdu
    neovim
    netcat-gnu
    nil
    nmap
    nodejs_22
    openssh
    parted
    pciutils
    poetry
    powertop
    psmisc
    pyright
    python312Full
    python312Packages.yt-dlp
    qrencode
    ranger
    ripgrep
    rustup
    starship
    strace
    sysbench
    tcpdump
    tmux
    torsocks
    traceroute
    tree
    unixtools.fdisk
    unixtools.xxd
    unzip
    upower
    util-linux
    wget
    xdg-user-dirs
    xdg-utils
    yq-go
    zip
    zoxide
    zstd
  ];
}
