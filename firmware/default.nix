{
  inputs,
  ...
}:
{
  transposition.firmware = {
    # Expose firmware as output
  };

  perSystem =
    {
      pkgs,
      lib,
      ...
    }:
    let
      inherit (pkgs) callPackage;
      path = inputs.self.lib.fetchQmkFirmwareHelperPath;
      fetchQmkFirmware = callPackage path { };
    in
    with lib;
    {

      options = with types; {
        firmware = mkOption {
          description = "The QMK firmware repository by version.";
          type = attrsOf package;
        };
      };

      config.firmware = import ./package-set.nix {
        inherit fetchQmkFirmware;
        inherit pkgs;
      };
    };
}
