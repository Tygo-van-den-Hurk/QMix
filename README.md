> Pronounced: "Q" "M" "ix", spelling the first two letters.

# QMix

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

Where ever you use packages, consume this overlay:

```Nix
{ inputs, ... }:
let
  pkgs = import <nixpkgs> {
    overlays = with inputs; [
      qmix.overlays.default
    ];
  };
in
  ...
```

Then you can freely use the helper functions `fetchQmkFirmware`, and `buildQmkFirmware`:

### fetchQmkFirmware

If you need a specific version of the QMK firmware repository you can fetch it like so:

```Nix
{
  firmware = pkgs.fetchQmkFirmware {
    rev = "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"; # or use tag
    hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA="
  };
}
```

You can even change the URL to fetch from. Uses `pkgs.fetchgit` under the hood.

This flake exposes a lot of QMK firmware versions already for you. You can use them like this:

```Nix
qmix.firmware.${system}.latest # defaults to the newest version
qmix.firmware.${system}."0"
qmix.firmware.${system}."0.33"
qmix.firmware.${system}."0.33.3"
qmix.firmware.${system}."0.33...."
qmix.firmware.${system}."0.33.0"
qmix.firmware.${system}."0.32"
qmix.firmware.${system}."0.32.16"
qmix.firmware.${system}."0.32...."
qmix.firmware.${system}."0.32.0"
qmix.firmware.${system}."0...."
```

All of them return the repository at that specific version. You can use them in [`buildQmkFirmware`](#buildqmkfirmware) as the firmware argument.

### buildQmkFirmware

If you want to build the firmware for a specific keyboard you can use the `buildQmkFirmware` function.

```Nix
{
  firmware = pkgs.buildQmkFirmware {
    keyboard = "my-keyboard/v1"; # required
    
  };
}
```

#### Changing Firmware Version

if you need a different QMK firmware version:

```Nix
{
  firmware = pkgs.buildQmkFirmware rec {
    ...
    qmkFirmware = "0.33.3"; # defaults to "latest"
  };
}
```

you can also swap out the QMK firmware package yourself using [`fetchQmkFirmware`](#fetchqmkfirmware):

```Nix
{
  firmware = pkgs.buildQmkFirmware rec {
    ...
    qmkFirmware = pkgs.fetchQmkFirmware {
      ...
    };
  };
}
```

#### Changing the Keymap

If you need a keymap that is not the the default keymap you can specify one like so:

```Nix
{
  firmware = pkgs.buildQmkFirmware rec {
    ...
    keymap = "qwerty"; # defaults to "default"
  };
}
```

#### Injecting Source Code

if you need to inject your keyboard in the repository:

```Nix
{
  firmware = pkgs.buildQmkFirmware rec {
    ...
    # in respect to "$QMK_FIRMWARE/", defaults to "keyboards/${keyboard}":
    srcMount = "...";
    src = ./some/path;
  };
}
```

This allows you to for example override a keyboard, or override one of it's key maps.

<!-- ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ -->

[nix]: http://nixos.org/
[qmk]: http://qmk.fm/
