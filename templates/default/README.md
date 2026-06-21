# QMix Template

This is a starter template created by [QMix] to build [qmk] using [nix]. To get started run:

```Shell
nix flake lock
```

to generate the lock file and commit it. Next you can add your source code to [src], and configure the nix code to build your keyboard/keymap in [nix/pkgs.nix][pkgs]. If you're stuck read the [docs] for [examples].

## Build your Firmware

To build your firmware, run:

```Shell
nix build
```

You should see a result directory with your firmware within it. Find out how to flash firmware to your particular board, and you're done!

[docs]: https://tygo-van-den-hurk.github.io/QMix/
[examples]: https://tygo-van-den-hurk.github.io/QMix/examples
[nix]: https://nixos.org/
[pkgs]: ./nix/pkgs.nix
[qmix]: https://github.com/Tygo-van-den-Hurk/QMix
[qmk]: https://github.com/qmk/qmk_firmware
[src]: ./src
