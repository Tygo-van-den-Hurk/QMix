{
  perSystem = { pkgs, ... }: {
    devShells."development" =
      with pkgs;
      let
        packages = [
          qmk
          git
        ];
      in
      mkShell {
        inherit packages;
      };
  };
}
