<div align="center">
  <!--~###################################~-->
  <!--~####    Open issues and PRs    ####~-->
  <!--~###################################~-->
  <a href="https://github.com/Tygo-van-den-Hurk/QMix/issues?q=is%3Aissue%20state%3Aopen%20label%3Afix">
    <picture>
      <source srcset="https://img.shields.io/github/issues/Tygo-van-den-Hurk/QMix/fix?style=flat&labelColor=FFFFFF&color=5277c3&logoColor=5E2751&label=Bug%20Reports" media="(prefers-color-scheme: light)" />
      <img src="https://img.shields.io/github/issues/Tygo-van-den-Hurk/QMix/fix?style=flat&labelColor=2F363D&color=415e9a&logoColor=8F5C86&label=Bug%20Reports" alt="open bug reports" />
    </picture>
  </a>
  <a href="https://github.com/Tygo-van-den-Hurk/QMix/issues?q=is%3Aissue%20state%3Aopen%20label%3Afeat">
    <picture>
      <source srcset="https://img.shields.io/github/issues/Tygo-van-den-Hurk/QMix/feat?style=flat&labelColor=FFFFFF&color=5277c3&logoColor=5E2751&label=Feature%20Requests" media="(prefers-color-scheme: light)" />
      <img src="https://img.shields.io/github/issues/Tygo-van-den-Hurk/QMix/feat?style=flat&labelColor=2F363D&color=415e9a&logoColor=8F5C86&label=Feature%20Requests" alt="open feature requests" />
    </picture>
  </a>
  <br>
  <!--~###################################~-->
  <!--~####     Repository Stats      ####~-->
  <!--~###################################~-->
  <a href="./LICENSE">
    <picture>
      <source srcset="https://img.shields.io/github/license/Tygo-van-den-Hurk/QMix?style=flat&labelColor=FFFFFF&color=5277c3&logoColor=5E2751&label=Licence" media="(prefers-color-scheme: light)" />
      <img src="https://img.shields.io/github/license/Tygo-van-den-Hurk/QMix?style=flat&labelColor=2F363D&color=415e9a&logoColor=8F5C86&label=Licence" alt="The Repository License badge" />
    </picture>
  </a>
  <a href="https://github.com/Tygo-van-den-Hurk/QMix/stargazers">
    <picture>
      <source srcset="https://img.shields.io/github/stars/Tygo-van-den-Hurk/QMix?style=flat&labelColor=FFFFFF&color=5277c3&label=Stars" media="(prefers-color-scheme: light)" />
      <img src="https://img.shields.io/github/stars/Tygo-van-den-Hurk/QMix?style=flat&labelColor=2F363D&color=415e9a&label=Stars" alt="amount of stars on GitHub" />
    </picture>
  </a>
  <a href="https://github.com/Tygo-van-den-Hurk/QMix/releases">
  <picture>
      <source srcset="https://img.shields.io/github/release/Tygo-van-den-Hurk/QMix?style=flat&display_name=release&label=Release&labelColor=FFFFFF&color=5277c3" media="(prefers-color-scheme: light)" />
      <img src="https://img.shields.io/github/release/Tygo-van-den-Hurk/QMix?style=flat&display_name=release&label=Release&labelColor=2F363D&color=415e9a" alt="newest release" />
  </picture>
  </a>
  <br>
  <!--~###################################~-->
  <!--~####      Repository CI/CD     ####~-->
  <!--~###################################~-->
  <a href="https://github.com/Tygo-van-den-Hurk/QMix/actions/workflows/many--basic-ci-checks.yaml">
    <picture>
      <source srcset="https://img.shields.io/github/actions/workflow/status/Tygo-van-den-Hurk/QMix/many--basic-ci-checks.yaml?style=flat&labelColor=FFFFFF&color=5277c3&logo=GitHub%20Actions&logoColor=000000&branch=main&event=push&label=CI" media="(prefers-color-scheme: light)" />
      <img src="https://img.shields.io/github/actions/workflow/status/Tygo-van-den-Hurk/QMix/many--basic-ci-checks.yaml?style=flat&labelColor=2F363D&color=415e9a&logo=GitHub%20Actions&logoColor=FFFFFF&branch=main&event=push&label=CI" alt="Basic CI/CD Checks" />
    </picture>
  </a>
  <a href="https://github.com/Tygo-van-den-Hurk/QMix/actions/workflows/cron--update-firmware.yaml">
    <picture>
      <source srcset="https://img.shields.io/github/actions/workflow/status/Tygo-van-den-Hurk/QMix/cron--update-firmware.yaml?style=flat&labelColor=FFFFFF&color=5277c3&logo=GitHub%20Actions&logoColor=000000&branch=main&label=QMK%20Up-to-date" media="(prefers-color-scheme: light)" />
      <img src="https://img.shields.io/github/actions/workflow/status/Tygo-van-den-Hurk/QMix/cron--update-firmware.yaml?style=flat&labelColor=2F363D&color=415e9a&logo=GitHub%20Actions&logoColor=FFFFFF&branch=main&label=QMK%20Up-to-date" alt="the status of whether or not the current QMK firmware version is up to date" />
    </picture>
  </a>
  <a href="https://github.com/Tygo-van-den-Hurk/QMix/actions/workflows/push--deploy-github-pages.yaml">
    <picture>
      <source srcset="https://img.shields.io/github/actions/workflow/status/Tygo-van-den-Hurk/QMix/push--deploy-github-pages.yaml?style=flat&labelColor=FFFFFF&color=5277c3&logo=readthedocs&logoColor=000000&branch=main&event=push&label=Docs" media="(prefers-color-scheme: light)" />
      <img src="https://img.shields.io/github/actions/workflow/status/Tygo-van-den-Hurk/QMix/push--deploy-github-pages.yaml?style=flat&labelColor=2F363D&color=415e9a&logo=readthedocs&logoColor=FFFFFF&branch=main&event=push&label=Docs" alt="Documentation build status" />
    </picture>
  </a>
</div>

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
