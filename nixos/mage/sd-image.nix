{ pkgs, ... }:

{
  imports = [
    <nixpkgs/nixos/modules/installer/sd-card/sd-image-aarch64.nix>
  ];


  boot.loader.grub.enable = false;
  boot.loader.generic-extlinux-compatible.enable = true;

  # Set the kernel
  boot.kernelPackages = pkgs.linuxPackages_hardened;
  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.forceImportRoot = false;

  networking.hostName = "mage";
  networking.hostId = "df1a2179";
  networking.networkmanager.enable = true;

  system.autoUpgrade = {
    enable = true;
    dates = "02:00";
    randomizedDelaySec = "45min";
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };

  # Firewall
  networking.firewall.enable = true;

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

  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  # Enable the X11 windowing system.
  # services.xserver.enable = true;

  # Configure keymap in X11
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # sound.enable = true;
  # hardware.pulseaudio.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  programs.fish.enable = true;

  users.users = {
    anon = {
      isNormalUser = true;
      extraGroups = [ "networkmanager" "wheel" ];
      packages = [ ];
      shell = pkgs.fish;
      initialPassword = "nixos";
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJvltRXYpfWZnU1GdBM4hAQOoKuUWgo5yhdM/6MVUYzP hunter"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHK2Aomah/vuuA7Xkb3WYQIoMcwEk2hbu2VEh30DmIdH paladin"
      ];
    };
  };

  # Workaround for nixos-rebuild switch failure
  # https://discourse.nixos.org/t/logrotate-config-fails-due-to-missing-group-30000/28501
  services.logrotate.checkConfig = false;

  # Syncthing
  services.syncthing.enable = true;

  # Tailscale
  services.tailscale.enable = true;

  # Swap
  swapDevices = [{
    device = "/var/lib/swapfile";
    size = 4 * 1024;
  }];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

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
    aria2
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
    gnumake
    gpa
    gsettings-desktop-schemas
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
    mako
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
    pciutils
    poetry
    powertop
    psmisc
    pyright
    python312Full
    qrencode
    ranger
    ripgrep
    rofi
    rustup
    starship
    strace
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
    wget
    xdg-utils
    yq-go
    zip
    zoxide
    zstd
  ];
}

