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

      config.firmware = import ./versions.nix {
        inherit fetchQmkFirmware;
      };

      config.apps.update-versions = with pkgs; rec {
        type = "app";

        meta = {
          description = "Update the `versions.nix` file.";
          maintainers = with maintainers; [
            Tygo-van-den-Hurk
          ];
        };

        program = "${lib.getExe (writeShellApplication {
          name = "update-versions";
          inherit meta;
          text = builtins.readFile ./update.bash;
          runtimeInputs = [
            nix-prefetch-git
            gnugrep
            gnused
            bash
            gawk
            git
            jq
          ];
        })}";
      };
    };
}
