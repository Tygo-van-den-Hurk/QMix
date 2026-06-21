# Call package arguments:
{
  python3Packages,
  qmkFirmware,
  stdenv,
  qmk,
  lib,
}:
let
  inherit (lib) isDerivation;
  specialArgs = {
    inherit qmk;
    inherit qmkFirmware;
  };
in
assert isDerivation qmk;
assert isDerivation qmkFirmware."latest" or false;

# arguments to `buildQmkFirmware`:
config@{ keyboard, ... }:
let
  args = lib.evalModules {
    inherit specialArgs;
    modules = [
      ./options.nix
      {
        inherit config;
      }
    ];
  };
in

stdenv.mkDerivation {
  name = "qmk-firmware";

  inherit (args.config) qmkUserspace;
  inherit (args.config) qmkFirmware;
  inherit (args.config) keyboard;
  inherit (args.config) srcMount;
  inherit (args.config) version;
  inherit (args.config) keymap;
  inherit (args.config) split;
  inherit (args.config) meta;
  inherit (args.config) qmk;
  inherit (args.config) src;

  propagatedBuildInputs = with python3Packages; [
    appdirs # required for qmk cli when building QMK firmware < v0.26.0
  ];

  env = {
    QMK_INTERACTIVE = "False";
    QMK_VERBOSE = "True";
    SKIP_GIT = "1";
    null = toString null;
    false = toString false;
  };

  unpackPhase = /* SHELL */ ''
    runHook preUnpack

    export PATH="''${qmk:+$qmk/bin''${PATH:+:}}$PATH"
    export HOME="$PWD"

    # Unpacking QMK firmware repository
    export QMK_HOME="$HOME/qmk_firmware"
    export QMK_FIRMWARE="$QMK_HOME"
    if [ "$qmkFirmware" == "$null" ]; then
      echo "ERROR: firmware is null"
      exit 1
    else # mounting firmware
      echo "using qmkFirmware: $qmkFirmware"
      cp "$qmkFirmware" --recursive "$QMK_FIRMWARE"
      chmod 777 "$QMK_FIRMWARE" --recursive
    fi

    # moving in the $src to $keyboardMount
    if [ "$src" != "$null" ]; then
      export QMIX_SRC_MNT="$QMK_HOME/$srcMount"
      mkdir --parents "$QMIX_SRC_MNT"
      cp "$src"/* --recursive "$QMIX_SRC_MNT"
    fi

    # Unpacking QMK userspace repository
    if [ "$qmkUserspace" != "$null" ]; then
      echo "using qmkUserspace: $qmkUserspace"
      export QMK_USERSPACE="$HOME/qmk_userspace"
      cp "$qmkUserspace" --recursive "$QMK_USERSPACE"
      chmod 777 "$QMK_USERSPACE" --recursive
    fi

    runHook postUnpack
  '';

  configurePhase = /* SHELL */ ''
    runHook preConfigure

    # setting up the config dir for QMK
    export XDG_CONFIG_HOME="$HOME/.config"
    mkdir --parents "$XDG_CONFIG_HOME"

    # Configuring QMK to behave the way thats desired
    qmk config general.interactive="$QMK_INTERACTIVE"
    qmk config general.verbose="$QMK_VERBOSE"
    qmk config user.qmk_home="$QMK_HOME"

    # Configuring QMK to use userspace if available.
    if [ -n "$QMK_USERSPACE" ]; then
      qmk config user.overlay_dir="$QMK_USERSPACE"
      cd "$QMK_USERSPACE"
    else # fall back to the old method
      cd "$QMK_FIRMWARE"
    fi

    export QMIX_OUT="$HOME/._out"
    mkdir --parents "$QMIX_OUT"

    runHook postConfigure
  '';

  buildPhase = /* SHELL */ ''
    runHook preBuild         

    compile() {
      qmk compile --clean \
        --parallel "$(nproc)" \
        --keyboard "$keyboard" \
        --keymap "$keymap" "$@"
    }

    if [ "$split" == "$false" ]; then
      compile
      cp "$QMK_HOME/.build"/*.{hex,bin,uf2,eep} "$QMIX_OUT"
    else
      mkdir --parents "$QMIX_OUT/left" "$QMIX_OUT/right"
      compile \
        --env handedness=left \
        --env SIDE=left \
        --env SPLIT=left
      cp "$QMK_HOME/.build"/*.{hex,bin,uf2,eep} "$QMIX_OUT/left"
      compile \
        --env handedness=right \
        --env SIDE=right \
        --env SPLIT=right
      cp "$QMK_HOME/.build"/*.{hex,bin,uf2,eep} "$QMIX_OUT/right"
    fi

    runHook postBuild
  '';

  installPhase = /* SHELL */ ''
    runHook preInstall

    # Copy results to the output
    mkdir --parents "$out/share/qmk-firmware"
    cp "$QMIX_OUT"/* --recursive "$out/share/qmk-firmware"

    runHook postInstall
  '';
}
