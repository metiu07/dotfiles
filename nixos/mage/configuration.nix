{ config, lib, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

  boot.loader.grub.enable = false;
  boot.loader.generic-extlinux-compatible.enable = true;

  # Set the kernel
  boot.kernelPackages = pkgs.linuxPackages_hardened;

  networking.hostName = "mage";
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

  system.activationScripts.sftp_data = ''
    mkdir -p /sftp
    chown root:root /sftp
    chmod 755 /sftp
    mkdir -p /sftp/anon_data
    chown anon_data:anon_data_g /sftp/anon_data
    chmod 770 /sftp/anon_data
  '';

  users.groups.anon_data_g = { };
  users.users = {
    anon = {
      isNormalUser = true;
      extraGroups = [ "networkmanager" "wheel" "anon_data_g" ];
      packages = with pkgs; [ ];
      shell = pkgs.fish;
      openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOfwRxqULadhhk84HROmF6DSbS75qDzguXWUGV4FQ5Wv anon@nixos" ];
    };
    anon_data = {
      isSystemUser = true;
      home = "/sftp/anon_data";
      group = "anon_data_g";
      openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOfwRxqULadhhk84HROmF6DSbS75qDzguXWUGV4FQ5Wv anon@nixos" ];
    };
    # anon_data = {
    #   isNormalUser = true;
    #   home = "/sftp/anon_data";
    #   extraGroups = [ "anon_data_g" ];
    #   openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOfwRxqULadhhk84HROmF6DSbS75qDzguXWUGV4FQ5Wv anon@nixos" ];
    # };
  };

  # Workaround for nixos-rebuild switch failure
  # https://discourse.nixos.org/t/logrotate-config-fails-due-to-missing-group-30000/28501
  services.logrotate.checkConfig = false;

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
    allowSFTP = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
    extraConfig = ''
      Match User anon_data
        ChrootDirectory /sftp
        PasswordAuthentication yes
        ForceCommand internal-sftp
    '';
  };

  # Needed in order to allow only anon_data to login with password
  security.pam.services.sshd.unixAuth = lib.mkForce true;

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
    btop
    curl
    delta
    docker-compose
    entr
    eza
    fd
    ffmpeg
    file
    fwupd
    fzf
    gcc
    gdb
    git
    glib
    gnumake
    htop
    imagemagick
    imhex
    jq
    libqalculate
    linuxHeaders
    lshw
    lsof
    ltrace
    ncdu
    neovim
    netcat-gnu
    openssh
    poetry
    powertop
    psmisc
    pyright
    python311Full
    qrencode
    ranger
    ripgrep
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
    util-linux
    wget
    xdg-utils
    yq-go
    zip
    zoxide
    zstd
  ];
}

