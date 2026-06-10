{
  imports = [
    ./development.nix
  ];

  # assign a default development shell
  perSystem = { self', ... }: {
    devShells = with self'; {
      default = devShells."development";
    };
  };
}
