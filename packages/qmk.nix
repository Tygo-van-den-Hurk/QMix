{
  perSystem = { pkgs, ... }: {
    packages.qmk = pkgs.qmk.overrideAttrs (oldAttrs: {
      propagatedBuildInputs = oldAttrs.propagatedBuildInputs ++ [
        pkgs.python3Packages.appdirs
      ];
    });
  };
}
