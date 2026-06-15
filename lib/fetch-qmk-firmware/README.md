# fetchQmkFirmware

This function is used to fetch a specific version of the QMK firmware repository. It is then primed for QMK so that QMK won't warn or crash when building.

## Fetching a Specific Version

If you need a specific version of the QMK firmware repository you can fetch it like so:

```Nix
{
  firmware = pkgs.fetchQmkFirmware {
    rev = "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"; # or use tag
    hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA="
  };
}
```

## Changing the Remote URL

You can even change the URL to fetch from. Uses `pkgs.fetchgit` under the hood.

```Nix
{
  firmware = pkgs.fetchQmkFirmware {
    remote = "git@example.com/USER/REPO.git";
    ...
  };
}
```

## Using Pre-Build firmware versions.

This flake exposes *a lot* of QMK firmware versions already for you. About 1660 at time of writing. You can use them like this:

```Nix
qmix.firmware.${system}.latest
qmix.firmware.${system}.v0
qmix.firmware.${system}.v0_33
qmix.firmware.${system}.v0_33_4
qmix.firmware.${system}.v0_33...
qmix.firmware.${system}.v0_33_0
qmix.firmware.${system}.v0_32
qmix.firmware.${system}.v0_32_16
qmix.firmware.${system}.v0_32...
qmix.firmware.${system}.v0_32_0
qmix.firmware.${system}.v0_...
```

All of them return the repository at that specific version. You can use them in [`buildQmkFirmware`][buildqmkfirmware] as the firmware argument for example.

[buildqmkfirmware]: ../build-qmk-firmware/README.md
