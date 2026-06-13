{
  pkgs,
  nvf,
  ...
}:
let
  neovimPackage = (import ./nvf { inherit pkgs nvf; }).neovim;
in
{
  environment.packages = with pkgs; [
    neovimPackage
    zsh
    git
    stow
    lsd
    atuin
    neofetch
    openssh
    zsh-powerlevel10k
    fzf
    gawk
    lazygit
    nodejs

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

  user.shell = "${pkgs.zsh}/bin/zsh";

  environment.etcBackupExtension = ".bak";
  system.stateVersion = "24.05";

  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  home-manager.config = ./home.nix;
}
