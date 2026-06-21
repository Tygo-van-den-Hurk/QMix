{
  # A collection of packages for the Nix package manager
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

  # Flake basics described using the module system
  inputs.flake-parts.url = "github:hercules-ci/flake-parts";

  # Allow flakes to be used with Nix < 2.4
  inputs.flake-compat = {
    url = "github:edolstra/flake-compat";
    flake = false;
  };

  # The library to build QMK firmware with using Nix.
  inputs.qmix = {
    url = "github:Tygo-van-den-Hurk/QMix";
    inputs.nixpkgs.follows = "nixpkgs";
    inputs.flake-parts.follows = "flake-parts";
    inputs.flake-compat.follows = "flake-compat";
  };

  # For more information on how to configure read: https://flake.parts/
  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = inputs.nixpkgs.lib.systems.flakeExposed;
      imports = [ ./nix ];
    };
}
