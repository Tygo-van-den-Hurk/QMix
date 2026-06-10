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
      keyboard = "planck/rev6";
      qmkFirmware = "0";
      split = true;
    };

    src2 = buildQmkFirmware {
      keyboard = "planck/rev6";
      qmkFirmware = 0;
      split = true;
    };

    src3 = buildQmkFirmware {
      keyboard = "planck/rev6";
      qmkFirmware = qmkFirmware."0";
      split = true;
    };

    meta = with lib; {
      description = "Test for the `buildQmkFirmware` helper function to see if it coerces well.";
      maintainers = with maintainers; [
        Tygo-van-den-Hurk
      ];
    };
  }
  (
    /* SHELL */ ''
      printf "The build firmware paths are: "
      jq -n \
        --arg src1 "$src1" \
        --arg src2 "$src2" \
        --arg src2 "$src3" \
        '$ARGS.named'

      if [ "$src1" != "$src2" ] || [ "$src1" != "$src3" ]; then
        echo ERROR: src1, src2, and src3 are not the same.
        echo this means that the coercing is not working well.
        exit 1
      fi

      touch "$out"
    ''
  )
