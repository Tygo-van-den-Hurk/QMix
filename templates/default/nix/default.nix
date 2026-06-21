{
  inputs,
  ...
}:
{
  imports = [
    ./pkgs.nix
    ./shells.nix
  ];

  perSystem = { system, ... }: {
    _module.args.pkgs = import inputs.nixpkgs {
      inherit system;
      overlays = [
        inputs.qmix.overlays.default
      ];
    };
  };
}
