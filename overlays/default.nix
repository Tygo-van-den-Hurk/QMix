{
  inputs,
  ...
}:
let
  fetchHelper = inputs.self.lib.fetchQmkFirmwareHelperPath;
  buildHelper = inputs.self.lib.buildQmkFirmwareHelperPath;
in
rec {
  flake.overlays.default = final: previous: rec {
    qmkFirmware = inputs.self.firmware.${final.stdenv.system};
    fetchQmkFirmware = previous.callPackage fetchHelper { };
    buildQmkFirmware = previous.callPackage buildHelper { };
  };

  perSystem =
    {
      system,
      ...
    }:
    let
      pkgs' = import inputs.nixpkgs {
        inherit system;
        overlays = [
          flake.overlays.default
        ];
      };
    in
    {
      checks.overlays =
        pkgs'.runCommand "test-fetch-qmk-firmware"
          rec {
            nativeBuildInputs = with pkgs'; [ jq ];

            fetched = pkgs'.fetchQmkFirmware {
              hash = "sha256-3otHYlL7IYS3VFd5/S/mBFUcZkT3Fvxo87l3VTDxbL0=";
              clearKeyboards = false;
              tag = "0.33.3";
            };

            build = pkgs'.buildQmkFirmware {
              qmkFirmware = fetched;
              keyboard = "planck/rev6";
              split = true;
            };

            meta = with pkgs'.lib; {
              description = "Tests for the `overlay` helper function.";
              maintainers = with maintainers; [
                Tygo-van-den-Hurk
              ];
            };
          }
          /* SHELL */ ''
            printf "The build firmware paths are: "
            jq -n \
              --arg out "$out" \
              --arg fetched "$fetched" \
              --arg build "$build" \
              '$ARGS.named'
            touch $out
          '';
    };
}
