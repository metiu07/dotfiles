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
    trustedInterfaces = [ "tailscale0" ];
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
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJARtGsacsO9AuHMPgNW+MshS9jJfRelXZwuSIn0LoVh paladin"
      ];
    };

    # immich.extraGroups = [ "video" "render" ];
  };

  services = {
    # SSH
    openssh = {
      enable = true;
      ports = [ 60416 ];
      openFirewall = true;
      settings = {
        PermitRootLogin = "no";
        PasswordAuthentication = false;
        LogLevel = "VERBOSE";
      };
    };

    # Fail2ban
    fail2ban = {
      enable = true;
    };

    # Syncthing
    # syncthing.enable = true;

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
    # immich = {
    #   enable = true;
    #   host = "0.0.0.0";
    #   machine-learning.enable = false;
    # };

    # Grafana
    grafana = {
      enable = true;
      settings = {
        server = {
          http_addr = "0.0.0.0";
          http_port = 3000;
          # Grafana needs to know on which domain and URL it's running
          # domain = "your.domain";
          # root_url = "https://your.domain/grafana/"; # Not needed if it is `https://your.domain/`
          # serve_from_sub_path = true;
        };
      };
    };

    # InfluxDB
    influxdb.enable = true;

    # OpenWebUI
    # open-webui = {
    #   enable = true;
    #   host = "0.0.0.0";
    # };

    # Jellyfin
    jellyfin = {
      enable = true;
      openFirewall = true;
    };

    # Adguard
    adguardhome = {
      enable = true;
      port = 3100;
      openFirewall = true;
      settings = {
        http = {
          address = "127.0.0.1:3003";
        };
        dns = {
          upstream_dns = [
            # Example config with quad9
            "9.9.9.9#dns.quad9.net"
            "149.112.112.112#dns.quad9.net"
          ];
        };
        filtering = {
          protection_enabled = true;
          filtering_enabled = true;

          parental_enabled = false; # Parental control-based DNS requests filtering.
          safe_search = {
            enabled = false; # Enforcing "Safe search" option for search engines, when possible.
          };
        };
      };
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
