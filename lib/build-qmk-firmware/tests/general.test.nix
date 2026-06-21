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

runCommand "test-build-qmk-firmware-general"
  {
    nativeBuildInputs = [
      git
      jq
    ];

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

      shopt -s nullglob
      shopt -s globstar

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

      if [ ! -d "$src1/share/qmk-firmware" ]; then
        echo ERROR: src1 is not a QMK firmware result.
        exit 1
      fi

      files=($src1/**/*.{hex,bin,uf2,eep})
      if [ ''${#files[@]} -eq 0 ]; then
        echo "no *.{hex,bin,uf2,eep} files found in: $src1"
        exit 1
      fi
    ''
    + /* SHELL */ ''

      ### src2 ###

      if [ ! -d "$src2/share/qmk-firmware" ]; then
        echo ERROR: src2 is not a QMK firmware result.
        exit 1
      fi

      files=($src2/**/*.{hex,bin,uf2,eep})
      if [ ''${#files[@]} -eq 0 ]; then
        echo "no *.{hex,bin,uf2,eep} files found in: $src2"
        exit 1
      fi

    ''
    + /* SHELL */ ''
      touch $out
    ''
  )
