{
  qmkFirmware,
  config,
  lib,
  qmk,
  ...
}:
let
  inherit (config) keyboard;
in
with lib;
{
  meta = {
    description = "The options you can pass to `buildQmkFirmware`.";
    maintainers = with maintainers; [
      Tygo-van-den-Hurk
    ];
  };

  options = with types; {

    keyboard = mkOption {
      description = "The keyboard to build firmware for.";
      example = "planck/rev3";
      type = singleLineStr;
    };

    keymap = mkOption {
      description = "The keymap to build firmware for.";
      type = singleLineStr;
      example = "custom";
      default = "default";
    };

    split = mkOption {
      description = "Whether or not this is a split keyboard.";
      default = false;
      example = true;
      type = bool;
    };

    src = mkOption {
      description = "Path to source code to inject in the qmk repository.";
      type = nullOr path;
      example = "./src";
      default = null;
    };

    srcMount = mkOption {
      description = "Where to mount `src` in the QMK firmware repository.";
      example = "keyboards/\${keyboard}/keymaps/\${keymap}";
      default = "keyboards/${keyboard}";
      type = nullOr singleLineStr;
    };

    version = mkOption {
      description = "The version of the firmware of this keyboard.";
      type = nullOr singleLineStr;
      example = "0.0.0";
      default = null;
    };

    meta = mkOption {
      description = "The meta data of this derivation.";
      type = attrsOf anything;
      default = {
        description = "Build QMK firmware for ${keyboard}";
      };
    };

    qmk = mkOption {
      description = "The QMK cli to use for this derivation.";
      type = package;
      default = qmk;
    };

    qmkUserspace = mkOption {
      description = "The QMK userspace to use in conjunction with the QMK firmware repository.";
      type = nullOr (either path package);
      default = null;
    };

    qmkFirmware = mkOption {
      description = "The QMK firmware repository to build this firmware with.";
      example = "v0";
      default = qmkFirmware."latest";
      type = either (either path package) (either singleLineStr int);
      apply =
        input:
        let
          getVersion =
            version:
            let
              noV = lib.removePrefix "v" (toString version);
              noDots = lib.replaceStrings [ "." ] [ "_" ] noV;
            in
            if version == "latest" then
              qmkFirmware."latest"
            else
              qmkFirmware."v${noDots}" or (throw "No such version: '${toString version}'.");
        in
        if isDerivation input || builtins.isPath input then input else getVersion input;
    };
  };
}
