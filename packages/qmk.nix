{
  perSystem = { pkgs, ... }: {
    packages.qmk =
      (pkgs.qmk.override {
        # use python 3.13, because some required code is deprecated and removed
        python3 = pkgs.python313;
      }).overrideAttrs
        (oldAttrs: {
          propagatedBuildInputs = oldAttrs.propagatedBuildInputs ++ [
            pkgs.python313Packages.appdirs
          ];
        });
  };
}
