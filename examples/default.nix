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

      entries = builtins.readDir ./.;
      directories = lib.filterAttrs (_: type: type == "directory") entries;
      paths = builtins.attrNames directories;
      examples = map (dir: ./. + "/${dir}/package.nix") paths;
      mkTest =
        path:
        callPackage path {
          inherit qmkFirmware;
          inherit fetchQmkFirmware;
          inherit buildQmkFirmware;
        };
    in
    {
      checks."examples" =
        pkgs.runCommand "all-examples-work"
          {
            buildInputs = map mkTest examples;
          }
          /* SHELL */ ''
            touch $out
          '';
    };
}
