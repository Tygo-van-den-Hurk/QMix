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

runCommand "test-build-qmk-firmware-coercing"
  {
    nativeBuildInputs = [
      git
      jq
    ];

    src0 = buildQmkFirmware {
      keyboard = "planck/rev6";
      qmkFirmware = qmkFirmware.v0;
      split = true;
    };

    src1 = buildQmkFirmware {
      keyboard = "planck/rev6";
      qmkFirmware = "v0";
      split = true;
    };

    src2 = buildQmkFirmware {
      keyboard = "planck/rev6";
      qmkFirmware = "0";
      split = true;
    };

    src3 = buildQmkFirmware {
      keyboard = "planck/rev6";
      qmkFirmware = 0;
      split = true;
    };

    meta = with lib; {
      description = "Test for the `buildQmkFirmware` helper function to see if it coerces version numbers well.";
      maintainers = with maintainers; [
        Tygo-van-den-Hurk
      ];
    };
  }
  (
    /* SHELL */ ''
      shopt -s nullglob
      shopt -s globstar

      printf "The build firmware paths are: "
      jq -n \
        --arg out "$out" \
        --arg src0 "$src0" \
        --arg src1 "$src1" \
        --arg src2 "$src2" \
        --arg src3 "$src3" \
        '$ARGS.named'

      if [ "$src0" != "$src1" ] \
      || [ "$src0" != "$src2" ] \
      || [ "$src0" != "$src3" ]; then
        echo ERROR: src1, src2, and src3 are not the same.
        echo this means that the coercing is not working well.
        exit 1
      fi

      files=($src0/**/*.{hex,bin,uf2,eep})
      if [ ''${#files[@]} -eq 0 ]; then
        echo "no *.{hex,bin,uf2,eep} files found in: $src0"
        exit 1
      fi
    ''
    + /* SHELL */ ''
      touch $out
    ''
  )
