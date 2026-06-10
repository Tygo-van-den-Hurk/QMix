{ inputs, ... }:
{
  imports = with inputs; [
    treefmt-nix.flakeModule
  ];

  perSystem.treefmt = {
    enableDefaultExcludes = true;
    flakeCheck = true;
    flakeFormatter = true;

    # nix formatting
    programs.nixfmt = {
      enable = true;
    };

    # nix static analysis
    programs.statix = {
      enable = true;
    };

    # find dead nix code
    programs.deadnix = {
      enable = true;
    };

    # markdown formatting
    programs.mdformat = {
      enable = true;
    };

    # Shell script formatting
    programs.shfmt = {
      enable = true;
    };

    # Shell script linting
    programs.shellcheck = {
      enable = true;
      excludes = [ "**/.env*" ];
    };
  };
}
