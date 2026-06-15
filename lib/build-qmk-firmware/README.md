# buildQmkFirmware

If you want to build the firmware for a specific keyboard you can use the **`buildQmkFirmware`** function:

```Nix
{
  firmware = pkgs.buildQmkFirmware {
    keyboard = "my-keyboard/v1"; # required
  };
}
```

But since you're not supplying code this does mean that `"my-keyboard/v1"` has to be in the QMK repository already at `/keyboards/my-keyboard/v1`. You can of course, [supply your own source code](#injecting-source-code).

## Injecting Source Code

There are 2 ways of building QMK firmware:

- The new way, using [QMK userspaces][qmk_userspace].
- Or the old way, with a clone of the [main QMK Repo][qmk_firmware].

**`buildQmkFirmware`** supports both methods.

### QMK Userspaces

The new way using Userspaces requires an extra argument, namely your userspace:

```Nix
{
  firmware = pkgs.buildQmkFirmware rec {
    ...
    qmkUserspace = ./some/path;
  };
}
```

**`buildQmkFirmware`** is smart enough to build your firmware using that userspace.

### Main QMK Firmware Repository

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

This allows you to for example override a keyboard, override one of it's key maps, or add your own.

## Changing Firmware Version

if you need a different QMK firmware version:

```Nix
{
  firmware = pkgs.buildQmkFirmware rec {
    ...
    qmkFirmware = "0.33.3"; # defaults to "latest"
  };
}
```

This default to `"latest"` for the absolute latest version of QMK.

The derivation is smart enough to understand you what version you want 90% of the time. For example, these are all legal inputs:

- get the absolute latest version: `"latest"` (default)
- specify an exact version: `"v0.0.0"`, `"0.0.0"`, `"v0_0_0"`, or `"0_0_0"`.
- get the newest minor version: `"v0.0"`, `"0.0"`, `"v0_0"`, or `"0_0"`.
- get the newest non breaking change: `"v0"`, `"0"` or `0`.

you can also swap out the QMK firmware package yourself using [`fetchQmkFirmware`][fetchqmkfirmware]:

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

This allows you to get an EXACT commit instead of a (in theory) mutable tag. See the documentation [`fetchQmkFirmware`][fetchqmkfirmware] for more options you can pass to it.

## Changing the Keymap

If you need a keymap that is not the the default keymap you can specify one like so:

```Nix
{
  firmware = pkgs.buildQmkFirmware rec {
    ...
    keymap = "qwerty"; # defaults to "default"
  };
}
```

This defaults to `"default"`. Which is at the time of writing also the QMK default value for keymap.

[fetchqmkfirmware]: ../fetch-qmk-firmware/README.md
[qmk_firmware]: https://github.com/qmk/qmk_firmware
[qmk_userspace]: https://github.com/qmk/qmk_userspace
