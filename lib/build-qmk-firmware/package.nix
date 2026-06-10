# Call package arguments:
{
  qmk,
  git,
  stdenv,
  qmkFirmware,
  lib,
}:

let # making sure that the variables aren't shadowed:
  qmkPkgs = qmk;
  qmkFirmwarePkgs = qmkFirmware;
in

# arguments to `buildQmkFirmware`:
{
  keyboard,
  keymap ? "default",
  srcMount ? "keyboards/${toString keyboard}", # the destination in respect to `$QMK_HOME`.
  qmkFirmware ? qmkFirmwarePkgs."latest",
  version ? null,
  split ? false,
  qmk ? qmkPkgs,
  src ? null,
}:

assert builtins.typeOf keyboard == "string";
assert builtins.typeOf srcMount == "string";

let # Coercing a string, or number into a QMK firmware package:
  getVersion = version: if qmkFirmwarePkgs ? "${toString version}" then
      qmkFirmwarePkgs."${toString version}"
    else
      throw "No such version: '${toString version}'.";
  
  error = "qmkFirmware argument is no as expected: ${toString qmkFirmware}";
  firmware = if lib.isDerivation qmkFirmware then
      qmkFirmware
    else if builtins.isString qmkFirmware then
      getVersion qmkFirmware
    else if builtins.isInt qmkFirmware then
      getVersion qmkFirmware
    else
      throw error;
in

stdenv.mkDerivation rec {
  name = "qmk-firmware";
  inherit version;

  nativeBuildInputs = [ git qmk ];

  dontUnpack = true;

  env.QMK_INTERACTIVE = "False";
  env.QMK_VERBOSE = "True";
  env.null = toString null;

  inherit src;
  inherit keyboard;
  inherit keymap;
  inherit srcMount;

  qmkFirmware = firmware;

  configurePhase = /* SHELL */ ''
    runHook preConfigure

    # Patching the environment for QMK
    export HOME="$PWD"
    export QMK_HOME="$HOME/qmk_firmware"
    export QMK_FIRMWARE="$QMK_HOME"

    # Setting up QMK firmware repository
    if [ "$qmkFirmware" == "$null" ]; then
      echo "WARNING: firmware is null"
    else # mounting firmware
      echo "using qmkFirmware: $qmkFirmware"
      cp "$qmkFirmware" --recursive "$QMK_HOME"
      chmod 777 "$QMK_FIRMWARE" --recursive
      cd "$QMK_FIRMWARE"
    fi

    # moving in the $src to $keyboardMount
    if [ "$src" == "$null" ]; then
      echo "WARNING: src argument is null."
      echo "this is fine if you're building a keyboard"
      echo "that is already in the main QMK repository."
    else # mounting src somewhere
      mkdir --parents "$QMK_HOME/$srcMount"
      cp $src/* --recursive "$QMK_HOME/$srcMount"
    fi

    # if both are null
    if [ "$qmkFirmware" == "$null" ] && [ "$src" == "$null" ]; then
      echo "ERROR: both src and firmware were null"
      exit 1
    fi

    runHook postConfigure
  '';

  buildPhase = /* SHELL */ ''
    runHook preBuild         

    # checking if the keyboard exists
    if [ "$keyboard" == "$null" ]; then
      echo "ERROR: No keyboard provided!"
      exit 1
    elif [ ! -d "$QMK_HOME/keyboards/$keyboard" ]; then
      echo "ERROR: No such keyboard: $keyboard"
      exit 1
    fi

    if [ "$split" == "${toString false}" ]; then
      echo 'building non-split keyboard'
      
      qmk compile --clean \
        --keyboard "$keyboard" \
        --keymap "$keymap"
      mkdir --parents "$PWD/.out"
      cp ./*.{hex,bin,uf2,eep} ./.out
    else
      echo 'building split keyboard'
      
      echo 'building left side'
      qmk compile --clean \
        --keyboard "$keyboard" \
        --keymap "$keymap" \
        --env handedness=left \
        --env SIDE=left
      mkdir --parents "$PWD/.out/left"
      cp ./*.{hex,bin,uf2,eep} "$PWD/.out/left"

      echo 'building right side'
      qmk compile --clean \
        --keyboard "$keyboard" \
        --keymap "$keymap" \
        --env handedness=right \
        --env SIDE=right
      mkdir --parents "$PWD/.out/right"
      cp ./*.{hex,bin,uf2,eep} "$PWD/.out/right"
    fi

    runHook postBuild
  '';

  installPhase = /* SHELL */ ''
    runHook preInstall

    # Copy results to the output
    mkdir --parents "$out/share/qmk/firmware"
    cp ./.out/* --recursive "$out/share/qmk/firmware"

    # add version metadata to the output
    echo "$(qmk --version)" > "$out/share/qmk/version"
    if [ "$version" != "${toString null}" ]; then
      echo "$version" > "$out/share/qmk/firmware-version"
    fi

    runHook postInstall
  '';

  meta.description = "Build QMK firmware for a specific keyboard.";
}
