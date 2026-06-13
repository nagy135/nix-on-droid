{
  description = "Basic example of Nix-on-Droid system config.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";

    nvf = {
      url = "github:notashelf/nvf/v0.6";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-on-droid = {
      url = "github:nix-community/nix-on-droid/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    nix-on-droid,
    nvf,
  }: {

    nixOnDroidConfigurations.default = nix-on-droid.lib.nixOnDroidConfiguration {
      pkgs = import nixpkgs { system = "aarch64-linux"; };
      modules = [
        { _module.args.nvf = nvf; }
        ./nix-on-droid.nix
      ];
    };

  };
}
