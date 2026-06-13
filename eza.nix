{ ... }:
{
  programs.eza = {
    enable = true;
    icons = true;
  };

  programs.zsh.shellAliases = {
    ls = "eza --icons";
    ll = "eza --icons -l";
    la = "eza --icons -la";
    lt = "eza --icons --tree";
  };
}
