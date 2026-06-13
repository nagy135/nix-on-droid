{
  pkgs,
  ...
}:
{
  home.packages = [ pkgs.atuin ];

  programs.atuin = {
    enable = true;
    enableZshIntegration = true;
    flags = [ "--disable-up-arrow" ];
  };
}
