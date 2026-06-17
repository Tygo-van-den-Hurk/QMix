{
  inputs,
  ...
}:
let
  inherit (inputs.self.lib) fetchQmkFirmwareHelperPath;
  inherit (inputs.self.lib) buildQmkFirmwareHelperPath;
in
{
  perSystem =
    {
      self',
      pkgs,
      lib,
      ...
    }:
    let
      inherit (pkgs) callPackage;
      qmkFirmware = self'.firmware;
      fetchQmkFirmware = callPackage fetchQmkFirmwareHelperPath { };
      buildQmkFirmware = callPackage buildQmkFirmwareHelperPath {
        inherit qmkFirmware;
      };

      mkTest =
        path:
        callPackage path {
          inherit qmkFirmware;
          inherit fetchQmkFirmware;
          inherit buildQmkFirmware;
        };
    in
    {
      checks."history" =
        let
          entries = builtins.readDir ./history;
          files = lib.filterAttrs (_: type: type == "regular") entries;
          paths = builtins.attrNames files;
          tests = map (file: ./history + "/${file}") paths;
        in
        pkgs.runCommand "test-history"
          {
            buildInputs = map mkTest tests;
            meta.description = "Make sure that the derivation is somewhat backwards compatible.";
          }
          /* SHELL */ ''
            echo $buildInputs > $out
          '';
    };
}
