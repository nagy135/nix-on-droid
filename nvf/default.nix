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
      ./modules/core.nix
      ./modules/navigation.nix
      ./modules/search.nix
      ./modules/git.nix
      ./modules/gitsigns.nix
      ./modules/tools.nix
      ./modules/debugger.nix
      ./modules/typescript.nix
      ./modules/notes.nix
    ];
  }
