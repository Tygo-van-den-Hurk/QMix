{
  inputs,
  ...
}:
let
  fetchHelper = inputs.self.lib.fetchQmkFirmwareHelperPath;
  buildHelper = inputs.self.lib.fetchQmkFirmwareHelperPath;
in
{
  flake.overlays.default =
    final: previous:
    (
      rec {
        qmkFirmware = inputs.self.firmware.${final.stdenv.system};
        fetchQmkFirmware = previous.callPackage fetchHelper { };
        buildQmkFirmware = previous.callPackage buildHelper { };
      }
      // inputs.self.packages.${final.stdenv.system}
    );
}
