{
  perSystem = { pkgs, ... }: {
    packages.qmk =
      (pkgs.qmk.override {
        # use python 3.13, because some required code is deprecated and removed
        python3Packages = pkgs.python313Packages;
      }).overrideAttrs
        (previous: {
          propagatedBuildInputs = (previous.propagatedBuildInputs or [ ]) ++ [
            pkgs.python313Packages.appdirs
          ];
        });
  };
}
