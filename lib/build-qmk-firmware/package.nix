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

assert lib.isDerivation qmkPkgs;
assert lib.isDerivation qmkFirmwarePkgs."latest" or false;

# arguments to `buildQmkFirmware`:
{
  keyboard,
  keymap ? "default",

  qmkUserspace ? null,
  version ? null,
  split ? false,

  src ? null,
  srcMount ? "keyboards/${toString keyboard}", # the destination in respect to `$QMK_HOME`.

  qmkFirmware ? qmkFirmwarePkgs."latest",
  qmk ? qmkPkgs,

  meta ? { },
}:

# asserting types to ensure correct usage of the function.
assert
  if builtins.typeOf keyboard != "string" then
    throw ''expected argument "keyboard" to be of type "string", but got: "${builtins.typeOf keyboard}"''
  else
    true;
assert
  if builtins.typeOf keymap != "string" then
    throw ''expected argument "keymap" to be of type "string", but got: "${builtins.typeOf keymap}"''
  else
    true;
assert
  if src != null && builtins.typeOf src != "string" && builtins.typeOf src != "path" then
    throw ''expected argument "src" to be of type "null", "string", or "path", but got: "${builtins.typeOf srcMount}"''
  else
    true;
assert
  if builtins.typeOf srcMount != "string" then
    throw ''expected argument "srcMount" to be of type "string", but got: "${builtins.typeOf srcMount}"''
  else
    true;
assert
  if !lib.isDerivation qmk then
    throw ''expected argument "qmk" to be of type "derivation", but got: "${builtins.typeOf qmk}"''
  else
    true;
assert
  let
    inherit (builtins) typeOf;
  in
  if
    !lib.isDerivation qmkFirmware && typeOf qmkFirmware != "string" && typeOf qmkFirmware != "int"
  then
    throw ''expected argument "qmkFirmware" to be of type "derivation", or "string", but got: "${builtins.typeOf qmkFirmware}"''
  else
    true;
assert
  if meta != null && builtins.typeOf meta != "set" then
    throw ''expected argument "meta" to be of type "null", or "set", but got: "${builtins.typeOf meta}"''
  else
    true;

let # Coercing a string, or number into a QMK firmware package:
  getVersion =
    version:
    let
      noV = lib.removePrefix "v" (toString version);
      noDots = lib.replaceStrings [ "." ] [ "_" ] noV;
    in
    if version == "latest" then
      qmkFirmwarePkgs."latest"
    else
      qmkFirmwarePkgs."v${noDots}" or (throw "No such version: '${toString version}'.");

  error = "qmkFirmware argument is no as expected: ${toString qmkFirmware}";
  firmware =
    if lib.isDerivation qmkFirmware || builtins.isPath qmkFirmware then
      qmkFirmware
    else if builtins.isString qmkFirmware then
      getVersion qmkFirmware
    else if builtins.isInt qmkFirmware then
      getVersion qmkFirmware
    else
      throw error;
in

assert lib.isDerivation firmware || builtins.isPath firmware;

stdenv.mkDerivation {
  name = "qmk-firmware";
  inherit version;

  inherit src;
  inherit keyboard;
  inherit keymap;
  inherit srcMount;
  inherit split;
  inherit qmkUserspace;
  qmkFirmware = firmware;

  nativeBuildInputs = [
    git
    qmk
  ];

  env = {
    QMK_INTERACTIVE = "False";
    QMK_VERBOSE = "True";
    null = toString null;
    false = toString false;
  };

  unpackPhase = /* SHELL */ ''
    runHook preUnpack

    # Patching the environment
    export HOME="$PWD"
    export XDG_CONFIG_HOME="$HOME/.config"
    mkdir --parents "$XDG_CONFIG_HOME"

    # Unpacking QMK firmware repository
    export QMK_HOME="$HOME/qmk_firmware"
    export QMK_FIRMWARE="$QMK_HOME"
    if [ "$qmkFirmware" == "$null" ]; then
      echo "ERROR: firmware is null"
      exit 1
    elif [ ! -e "$qmkFirmware" ]; then
      echo "ERROR: firmware path does not exist."
      exit 1
    else # mounting firmware
      echo "using qmkFirmware: $qmkFirmware"
      cp "$qmkFirmware" --recursive "$QMK_FIRMWARE"
      chmod 777 "$QMK_FIRMWARE" --recursive
    fi

    # moving in the $src to $keyboardMount
    if [ "$src" == "$null" ]; then
      echo "WARNING: src argument is null."
      echo "this is fine if you're building a keyboard"
      echo "that is already in the main QMK repository."
    else # mounting src somewhere
      export QMIX_SRC_MNT="$QMK_HOME/$srcMount"
      echo "Copying src '$src' into '$QMIX_SRC_MNT'."
      mkdir --parents "$QMIX_SRC_MNT"
      cp "$src"/* --recursive "$QMIX_SRC_MNT"
      echo "Contents of '$QMIX_SRC_MNT' of afterwards:"
      ls "$QMIX_SRC_MNT" -all
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
      echo 'building non-split keyboard'
      compile
      cp "$QMK_HOME/.build"/*.{hex,bin,uf2,eep} "$QMIX_OUT"
    else
      echo 'building split keyboard'
      echo 'building left side'
      mkdir --parents "$QMIX_OUT/left"
      compile \
        --env handedness=left \
        --env SIDE=left \
        --env SPLIT=left
      cp "$QMK_HOME/.build"/*.{hex,bin,uf2,eep} "$QMIX_OUT/left"
      echo 'building right side'
      mkdir --parents "$QMIX_OUT/right"
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

    echo 'ls "$QMIX_OUT"' && ls "$QMIX_OUT" -all

    # Copy results to the output
    mkdir --parents "$out/share/qmk/firmware"
    cp "$QMIX_OUT"/* --recursive "$out/share/qmk/firmware"

    # add version metadata to the output
    echo "$(qmk --version)" > "$out/share/qmk/version"
    if [ "$version" != "$null" ]; then
      echo "$version" > "$out/share/qmk/firmware-version"
    fi

    runHook postInstall
  '';

  meta = {
    description = "Build QMK firmware for ${keyboard}";
  }
  // meta;
}
