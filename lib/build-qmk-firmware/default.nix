{
  # Checks the `buildQmkFirmware` function.
  config.perSystem = { pkgs, self', ... }: {
    checks = with pkgs; {
      buildQmkFirmware = 
        let 
          test = path: callPackage path { 
            qmkFirmware = self'.firmware;
          };
        in
          symlinkJoin {
            name = "all-tests-for-buildQmkFirmware";
            paths = map test [
              ./coercing.test.nix
              ./general.test.nix
              ./split.test.nix
            ];
          };
    };
  };
}
