# QMix

> Pronounced: "Q" "M" "ix", spelling the first two letters the "ix" pronounced as in Nix.

Build [QMK firmware][qmk] with [Nix] using these helper functions!

## Setup

Add this flake to your flake's inputs:

```Nix
{
  inputs = {
    nixpkgs.url = "...";
    qmix = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "...";
    };
  };
}
```

After adding it to your flake's inputs, make sure to run `nix flake lock` to update the lock file.

## Usage

Where ever you use `nixpkgs`, consume this overlay:

```Nix
{ nixpkgs, qmix, ... }:
let
  pkgs = import nixpkgs {
    overlays = [
      qmix.overlays.default
    ];
  };
in
  ...
```

Then you can freely use the helper functions [`fetchQmkFirmware`][fetchqmkfirmware], and [`buildQmkFirmware`][buildqmkfirmware] to build [QMK] firmware using [Nix]. See their respective documentation pages for more information.

[buildqmkfirmware]: ./lib/build-qmk-firmware/README.md
[fetchqmkfirmware]: ./lib/fetch-qmk-firmware/README.md
[nix]: http://nixos.org/
[qmk]: http://qmk.fm/
