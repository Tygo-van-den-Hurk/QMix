{
  perSystem = { pkgs, ... }: rec {
    checks.default = packages.default;
    packages.default = pkgs.buildQmkFirmware {
      keyboard = "custom-keyboard";
      src = ../src; # remove this if you don't need source injection.
    };
  };
}
