{
  fetchFromGitHub,
  qmkFirmware,
  callPackage,
  runCommand,
  package,
  lib,
  jq,
}:

let
  buildQmkFirmware = callPackage package {
    inherit qmkFirmware;
  };
in

runCommand "test-build-qmk-firmware-userspace"
  {
    nativeBuildInputs = [
      jq
    ];

    src0 = buildQmkFirmware {
      keyboard = "cradio";
      split = true;
      qmkUserspace = fetchFromGitHub {
        owner = "filterPaper";
        repo = "qmk_userspace";
        rev = "9075e194d51677ce75bc8516e21eb02acdf11034";
        hash = "sha256-k1Jr30L+qbtQPpJrAMEb95SMppWHxIyrxq+xLs0KPPk=";
      };
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
        '$ARGS.named'

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
