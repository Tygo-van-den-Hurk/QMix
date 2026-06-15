{
  qmkFirmware,
  callPackage,
  runCommand,
  package,
  git,
  lib,
  jq,
}:

let
  buildQmkFirmware = callPackage package {
    inherit qmkFirmware;
  };
in

runCommand "test-build-qmk-firmware-split"
  {
    nativeBuildInputs = [
      git
      jq
    ];

    src1 = buildQmkFirmware {
      qmkFirmware = "0.32.16";
      keyboard = "preonic/rev3";
      split = false;
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
        --arg out "$out" \
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

      if [ -d "$src1/share/qmk/firmware/left" ]; then
        echo "ERROR: src1 has a 'left' directory"
        echo "src1 is not a split keyboard but it contains"
        echo "the left directory which is for split keyboards"
        echo "only. Thus something went wrong."
        exit 1
      fi

    ''
    + /* SHELL */ ''

      ### src2 ###

      if [ ! -d "$src2/share/qmk" ]; then
        echo ERROR: src2 is not a QMK firmware result.
        exit 1
      fi

      if [ ! -d "$src2/share/qmk/firmware/left" ]; then
        echo "ERROR: src2 does not have a 'left' directory"
        echo "src2 is a split keyboard so it should contain"
        echo "a left directory. It did not, thus something"
        echo "went wrong."
        exit 1
      fi

    ''
    + /* SHELL */ ''
      touch $out
    ''
  )
