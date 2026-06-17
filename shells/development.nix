{
  perSystem =
    {
      config,
      pkgs,
      ...
    }:
    let
      formatters = builtins.attrValues config.treefmt.build.programs;
      hooks = config.pre-commit.settings.enabledPackages;
      packages = with pkgs; [
        act # Run your GitHub Actions locally
        git # Distributed version control system
        qmk # Compile QMK firmware
      ];

      buildInputs = packages ++ formatters ++ hooks;

      shellHook = ''
        ${config.pre-commit.shellHook}
        if [ -f .env ]; then
          source .env
        fi
      '';
    in
    {
      devShells."development" = pkgs.mkShell {
        inherit buildInputs;
        inherit shellHook;
      };
    };
}
