{
  config,
  lib,
  pkgs,
  ...
}:
let
  fontPkg = pkgs.nerdfonts.override { fonts = [ "Mononoki" ]; };
  fontSrc = "${fontPkg}/share/fonts/truetype/NerdFonts/MononokiNerdFont-Regular.ttf";
  fontDst = "${config.home.homeDirectory}/.termux/font.ttf";
in
{
  imports = [
    ./atuin.nix
    ./zsh.nix
  ];

  home.stateVersion = "24.05";

  home.activation.copyFont = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if [ ! -e "${fontDst}" ] || ! cmp -s "${fontSrc}" "${fontDst}"; then
      $DRY_RUN_CMD install $VERBOSE_ARG -D -m 0644 "${fontSrc}" "${fontDst}"
    fi
  '';
}
