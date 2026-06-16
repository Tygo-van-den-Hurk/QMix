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
      clearKeyboards = false;
      tag = "0.33.3";
    };

    src2 = fetchQmkFirmware {
      hash = "sha256-a4BHtrI9il42WzSPWFaG5uH0iz6tjmdVKtbUhZacrOw=";
      rev = "c53dd0fbb6eefa3f45085bae44dd35ddafa6045b"; # 0.33.2
      clearKeyboards = true;
    };

    meta = with lib; {
      description = "Tests for the `fetchQmkFirmware` helper function.";
      maintainers = with maintainers; [
        Tygo-van-den-Hurk
      ];
    };
  }
  (
    /* SHELL */ ''
      # This test script tests: fetchQmkFirmware

      echo "src1=$src1"
      echo "src2=$src2"

      # assert src1 != src2
      [ "$src1" != "$src2" ] || {
        echo "ERROR: src1 and src2 seem to be the same thing"
        exit 1
      }

    ''
    + /* SHELL */ ''

      ### src1 ###

      # assert src1 is a valid QMK git repository
      echo "src1 = $src1"
      [ -d "$src1/.git" ] || {
        echo "ERROR: src1 missing .git"
        exit 1
      }

      git -c safe.directory='*' -C "$src1" remote get-url origin | grep qmk_firmware || {
        echo "ERROR: src1 does not have qmk_firmware as it's origin"
        exit 1
      }

      [ -n "$(ls -A "$src1/keyboards" 2>/dev/null)" ] || {
        echo "ERROR: src1 cleared keyboards directory"
        exit 1
      }

    ''
    + /* SHELL */ ''

      ### src2 ###

      # assert src2 is a valid QMK git repository
      echo "src2 = $src2"
      [ -d "$src2/.git" ] || {
        echo "ERROR: src2 missing .git"
        exit 1
      }

      git -c safe.directory='*' -C "$src2" remote get-url origin | grep qmk_firmware || {
        echo "ERROR: src2 does not have qmk_firmware as it's origin"
        exit 1
      }

      # Check clearKeyboards=true
      [ -z "$(ls -A "$src2/keyboards" 2>/dev/null)" ] || {
        echo "ERROR: src2 did not clear keyboards directory"
        ls $src2/keyboards
        exit 1
      }

    ''
    + /* SHELL */ ''
      touch "$out"
    ''
  )
