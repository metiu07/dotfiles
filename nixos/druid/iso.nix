# Building:
# ```bash
# # I had some issues with this command
# nix-build '<nixpkgs/nixos>' -A config.system.build.isoImage -I nixos-config=iso.nix
# 
# git clone -b nixos-23.11 https://github.com/NixOS/nixpkgs --depth 1 /tmp/nixpkgs
# nix-build '<nixpkgs/nixos>' -A config.system.build.isoImage -I nixpkgs=/tmp/nixpkgs/ -I nixos-config=iso.nix
# ```

{ config, pkgs, ... }:
{
  imports = [
    <nixpkgs/nixos/modules/installer/cd-dvd/installation-cd-graphical-calamares-gnome.nix>

    # Provide an initial copy of the NixOS channel so that the user
    # doesn't need to run "nix-channel --update" first.
    <nixpkgs/nixos/modules/installer/cd-dvd/channel.nix>
  ];

  networking.networkmanager.enable = true;
  networking.wireless.enable = false;
  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # boot.blacklistedKernelModules = [ "rtl8xxau" ]
  # boot.extraModulePackages = [ config.boot.kernelPackages.rtl8812au ];
  boot.extraModulePackages = [
    config.boot.kernelPackages.rtl88xxau-aircrack
    config.boot.kernelPackages.rtl8812au
    config.boot.kernelPackages.rtl8821au
  ];
  # boot.kernelModules = [ "rtl8812au" ];
  boot.kernelModules = [
    "rtl8821au"
    "rtl88xxau-aircrack"
  ];

  # Configure keymap in X11
  services.xserver = {
    layout = "us,sk";
    xkbVariant = "colemak_dh,qwerty";
    xkbOptions = "caps:escape,altwin:swap_lalt_lwin";
  };

  environment.systemPackages = with pkgs; [
    alacritty
    btop
    btrfs-progs
    curl
    dosfstools
    exfatprogs
    fatresize
    fd
    file
    fish
    fwupd
    fzf
    gcc
    gdb
    git
    gnumake
    gparted
    htop
    linuxHeaders
    lshw
    lsof
    meld
    ncdu
    neovim
    nmap
    openssh
    parted
    pciutils
    powertop
    psmisc
    ripgrep
    tcpdump
    tmux
    traceroute
    unixtools.fdisk
    unixtools.xxd
    unzip
    util-linux
    vscodium
    wget
    zip
    zstd
  ];
}
