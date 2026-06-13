{ pkgs, ... }:
{
  environment.packages = with pkgs; [
    neovim
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

  environment.etcBackupExtension = ".bak";
  system.stateVersion = "24.05";

  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  home-manager.config = ./home.nix;
}
