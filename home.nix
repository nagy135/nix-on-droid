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
  home.stateVersion = "24.05";

  programs.zsh = {
    enable = true;
    initExtra = ''
      export PATH=$PATH:$HOME/.scripts
      source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme

      [[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh
    '';
  };

  home.activation.copyFont = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if [ ! -e "${fontDst}" ] || ! cmp -s "${fontSrc}" "${fontDst}"; then
      $DRY_RUN_CMD install $VERBOSE_ARG -D -m 0644 "${fontSrc}" "${fontDst}"
    fi
  '';
}
