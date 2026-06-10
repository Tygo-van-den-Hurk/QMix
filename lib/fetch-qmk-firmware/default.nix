{
  # Checks the `fetchQmkFirmware` function.
  perSystem = { pkgs, ... }: {
    checks = with pkgs; {
      fetchQmkFirmware = callPackage ./test.nix { };
    };
  };
}
