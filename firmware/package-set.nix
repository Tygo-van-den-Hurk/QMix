{ lib, fetchQmkFirmware }:

let
  versions = import ./versions.nix;

  sortedVersions =
    lib.sort lib.versionOlder (builtins.attrNames versions);

  mkName = version:
    "v${builtins.replaceStrings [ "." ] [ "_" ] version}";

  mkPackage = version:
    fetchQmkFirmware {
      tag = version;
      hash = versions.${version};
    };

  result =
    builtins.foldl' (
      acc: version:
      let
        parts = lib.splitString "." version;

        major = "v${builtins.elemAt parts 0}";
        minor =
          if builtins.length parts >= 2 then
            "${major}_${builtins.elemAt parts 1}"
          else
            major;

        full = mkName version;
        pkg = mkPackage version;
      in
      acc // {
        ${full} = pkg;

        # Since versions are processed oldest → newest,
        # these aliases will always point to the latest version.
        ${major} = pkg;
        ${minor} = pkg;
        latest = pkg;
      }
    )
    {}
    sortedVersions;

in
result