# Based on: https://drakerossman.com/blog/how-to-convert-default-nixos-to-nixos-with-flakes
# This can be built with nixos-rebuild --flake .#hunter build
{
  description = "the simplest flake for nixos-rebuild";

  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-24.11";
      # url = "github:NixOS/nixpkgs/nixos-24.05";
      # url = "github:NixOS/nixpkgs/nixos-unstable";
      # url = "github:NixOS/nixpkgs/dd37924974b9202f8226ed5d74a252a9785aedf8";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  };

  # Outputs can be anything, but the wiki + some commands define their own
  # specific keys. Wiki page: https://nixos.wiki/wiki/Flakes#Output_schema
  outputs = { self, nixpkgs, nixos-hardware }: {
    # nixosConfigurations is the key that nixos-rebuild looks for.
    nixosConfigurations = {
      hunter = nixpkgs.lib.nixosSystem {
        # A lot of times online you will see the use of flake-utils + a
        # function which iterates over many possible systems. My system
        # is x86_64-linux, so I'm only going to define that
        system = "x86_64-linux";
        # Import our old system configuration.nix
        modules = [
          ./configuration.nix
          nixos-hardware.nixosModules.dell-latitude-7420
        ];
      };
    };
  };
}

