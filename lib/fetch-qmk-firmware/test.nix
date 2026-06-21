{
  callPackage,
  runCommand,
  git,
  lib,
}:

let
  fetchQmkFirmware = callPackage ./package.nix { };
in

runCommand "test-fetch-qmk-firmware"
  {
    nativeBuildInputs = [ git ];

    src1 = fetchQmkFirmware {
      hash = "sha256-3otHYlL7IYS3VFd5/S/mBFUcZkT3Fvxo87l3VTDxbL0=";
      tag = "0.33.3";
    };

    src2 = fetchQmkFirmware {
      hash = "sha256-a4BHtrI9il42WzSPWFaG5uH0iz6tjmdVKtbUhZacrOw=";
      rev = "c53dd0fbb6eefa3f45085bae44dd35ddafa6045b"; # 0.33.2
    };

    meta = with lib; {
      description = "Tests for the `fetchQmkFirmware` helper function.";
      maintainers = with maintainers; [
        Tygo-van-den-Hurk
      ];
    };
  }
  ''
    # This test script tests: fetchQmkFirmware

    echo "src1=$src1"
    echo "src2=$src2"

    # assert src1 != src2
    [ "$src1" != "$src2" ] || {
      echo "ERROR: src1 and src2 seem to be the same thing"
      exit 1
    }

    touch "$out"
  ''
