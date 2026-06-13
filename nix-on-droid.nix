{ config, lib, pkgs, ... }:

{
  # Simply install just the packages
  environment.packages = with pkgs; [
    # User-facing stuff that you really really want to have
    neovim # or some other editor, e.g. nano or neovim
    zsh
    git
    stow
    lsd
    atuin
    neofetch
    openssh
    nerdfonts
    zsh-powerlevel10k
    fzf
    gawk
    lazygit

    # Some common stuff that people expect to have
    procps
    killall
    diffutils
    findutils
    utillinux
    tzdata
    hostname
    man
    gnugrep
    gnupg
    gnused
    gnutar
    bzip2
    gzip
    xz
    zip
    unzip
  ];


  # Backup etc files instead of failing to activate generation if a file already exists in /etc
  environment.etcBackupExtension = ".bak";

  # Read the changelog before changing this value
  system.stateVersion = "24.05";

  # Set up nix for flakes
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';
  home-manager.config =
    { config, lib, pkgs, ... }:
    let
      fontPkg = pkgs.nerdfonts.override { fonts = [ "FiraCode" ]; };
      fontSrc = "${fontPkg}/share/fonts/truetype/NerdFonts/FiraCodeNerdFont-Regular.ttf";
      fontDst = "${config.home.homeDirectory}/.termux/font.ttf";
    in
    {
      home.stateVersion = "24.05";
      programs.zsh = {

      enable = true;

      initExtra = ''
      	export PATH=$PATH:$HOME/.scripts

        source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme

        # Optional, only if you have generated this file:

        [[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

      '';

    };

      home.activation.copyFont = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        if [ ! -e "${fontDst}" ] || ! cmp -s "${fontSrc}" "${fontDst}"; then
          $DRY_RUN_CMD install $VERBOSE_ARG -D -m 0644 "${fontSrc}" "${fontDst}"
        fi
      '';
    };

# Set your time zone
#time.timeZone = "Europe/Berlin";
}
