{
  pkgs,
  nvf,
}: let
  nvfPkgs = pkgs;
  configModule = import ./config.nix {
    pkgs = nvfPkgs;
    lib = nvfPkgs.lib;
  };
in
  nvf.lib.neovimConfiguration {
    pkgs = nvfPkgs;
    modules = [
      configModule
      ./modules/debugger.nix
    ];
  }
