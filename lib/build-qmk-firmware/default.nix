{
  # Checks the `buildQmkFirmware` function.
  config.perSystem = { pkgs, self', ... }: {
    checks = with pkgs; {
      buildQmkFirmware =
        let
          test =
            path:
            callPackage path {
              qmkFirmware = self'.firmware;
              package = ./package.nix;
            };
        in
        runCommand "all-tests-for-buildQmkFirmware"
          {
            buildInputs = map test [
              # ./tests/build-userspace.test.nix
              ./tests/coercing.test.nix
              ./tests/general.test.nix
              ./tests/split.test.nix
            ];
          }
          /* SHELL */ ''
            echo "$0" > $out
          '';
    };
  };
}
