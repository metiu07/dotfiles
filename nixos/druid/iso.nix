# Building:
# nix-build '<nixpkgs/nixos>' -A config.system.build.isoImage -I nixos-config=iso.nix

{ config, pkgs, ... }:
{
  imports = [
    <nixpkgs/nixos/modules/installer/cd-dvd/installation-cd-graphical-gnome.nix>

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


  environment.systemPackages = with pkgs; [
    alacritty
    linuxHeaders
    htop
    neovim
    git
    fish
    gcc
    gnumake
    vscodium
    util-linux
  ];
}
