{
  qmkFirmware,
  callPackage,
  runCommand,
  git,
  lib,
  jq,
}:

let
  buildQmkFirmware = callPackage ./package.nix {
    inherit qmkFirmware;
  };
in

runCommand "test-build-qmk-firmware"
  {
    nativeBuildInputs = [ git jq ];

    src1 = buildQmkFirmware {
      qmkFirmware = "0.33.3";
      keyboard = "planck/rev6";
      split = true;
    };

    src2 = buildQmkFirmware {
      qmkFirmware = "0.32.16";
      keyboard = "planck/rev6";
      split = true;
    };

    meta = with lib; {
      description = "Tests for the `buildQmkFirmware` helper function.";
      maintainers = with maintainers; [
        Tygo-van-den-Hurk
      ];
    };
  }
  (
    /* SHELL */ ''
      # This test script tests: buildQmkFirmware

      printf "The build firmware paths are: "
      jq -n \
        --arg src1 "$src1" \
        --arg src2 "$src2" \
        '$ARGS.named'

      if [ "$src1" == "$src2" ]; then
        echo ERROR: src1, and src2 should be different from the other.
        echo ones this means that the QMK firmware is always the same.
        exit 1
      fi

    ''
    + /* SHELL */ ''

      ### src1 ###

      if [ ! -d "$src1/share/qmk" ]; then
        echo ERROR: src1 is not a QMK firmware result.
        exit 1
      fi

    ''
    + /* SHELL */ ''

      ### src2 ###

      if [ ! -d "$src2/share/qmk" ]; then
        echo ERROR: src2 is not a QMK firmware result.
        exit 1
      fi

    ''
    + /* SHELL */ ''
      touch "$out"
    ''
  )
