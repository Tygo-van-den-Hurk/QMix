{ pkgs, fetchQmkFirmware }:

let
  inherit (pkgs) lib;

  versions = import ./versions.nix;

  mkQmkFirmware =
    {
      version,
      hash ? versions.${version},
    }:
    fetchQmkFirmware {
      inherit hash;
      tag = version;
    };

  validVersions = lib.filterAttrs (_: hash: hash != null) versions;

  generated = lib.mapAttrs' (
    version: hash:
    lib.nameValuePair version (mkQmkFirmware {
      inherit version hash;
    })
  ) validVersions;

  versionNames = builtins.attrNames validVersions;

  sortedVersions = builtins.sort lib.versionOlder versionNames;

  latest = lib.last sortedVersions;

  aliases =
    let
      grouped = builtins.foldl' (
        acc: version:
        let
          parts = lib.splitString "." version;

          major = builtins.elemAt parts 0;

          majorMinor = "${major}.${builtins.elemAt parts 1}";
        in
        acc
        // {
          ${major} = (acc.${major} or [ ]) ++ [ version ];

          ${majorMinor} = (acc.${majorMinor} or [ ]) ++ [ version ];
        }
      ) { } sortedVersions;
    in
    lib.mapAttrs' (
      alias: versions:
      let
        newest = lib.last (builtins.sort lib.versionOlder versions);
      in
      lib.nameValuePair alias generated.${newest}
    ) grouped;

in
generated
// aliases
// {
  latest = generated.${latest};
}
