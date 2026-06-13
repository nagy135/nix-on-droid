{
  pkgs,
  lib,
  ...
}: let
  typebreakPlugin = pkgs.vimUtils.buildVimPlugin {
    pname = "typebreak.nvim";
    version = "unstable-2026-03-31";
    dependencies = [pkgs.vimPlugins.plenary-nvim];
    src = pkgs.fetchFromGitHub {
      owner = "nagy135";
      repo = "typebreak.nvim";
      rev = "51f4e4410272df8a9b31eda06be2e81bc4260aa6";
      sha256 = "sha256-TJbhl9CsbCwma3w+IzY0a0nwMw826U04AKXd0nW2lvo=";
    };
  };

  polarPlugin = pkgs.vimUtils.buildVimPlugin {
    pname = "polar.vim";
    version = "unstable-2026-03-31";
    src = pkgs.fetchFromGitHub {
      owner = "weihanglo";
      repo = "polar.vim";
      rev = "0a4bc09d5a542f62ce97b9135b55793b09ecdfe7";
      sha256 = "18fbphj8nhvp9m7i6lbciwqprvx1c4z6rmlg4bm07k1b8brjsdyz";
    };
  };
in {
  config.vim = {
    viAlias = true;
    vimAlias = true;
    withNodeJs = true;
    withPython3 = true;
    enableLuaLoader = true;

    extraPackages = with pkgs; [
      alejandra
      black
      isort
      prettierd
      stylua
    ];

    lsp = {
      enable = true;
      formatOnSave = false;
      lspSignature.enable = false;
      trouble.enable = false;
    };

    autopairs = {
      enable = true;
      type = "nvim-autopairs";
    };
    snippets.vsnip.enable = true;

    binds.whichKey = {
      enable = true;
    };

    git = {
      enable = true;
      gitsigns.enable = true;
      # neogit.enable = false;
    };

    telescope.enable = true;

    tabline.nvimBufferline.enable = true;

    notify.nvim-notify.enable = true;

    visuals = {
      nvimWebDevicons.enable = true;
      fidget-nvim.enable = true;
    };

    languages = {
      enableFormat = true;
      enableLSP = true;
      enableTreesitter = true;
      enableExtraDiagnostics = true;

      bash.enable = true;
      html.enable = true;
      lua.enable = true;
      markdown.enable = false;
      nix.enable = true;
      python.enable = true;
      ts = {
        enable = true;
        format.enable = true;
      };
    };

    startPlugins = with pkgs.vimPlugins; [
      catppuccin-nvim
      gruvbox-material
      kanagawa-nvim
      nord-nvim
      vim-sleuth
      mini-nvim
      telescope-fzf-native-nvim
      telescope-ui-select-nvim
      polarPlugin
    ];

    luaConfigPre = ''
      vim.g.mapleader = " "
      vim.g.maplocalleader = " "
      vim.g.have_nerd_font = true

      vim.opt.number = true
      vim.opt.relativenumber = true
      vim.opt.clipboard = "unnamedplus"
      vim.opt.mouse = "a"
      vim.opt.showmode = false
      vim.opt.termguicolors = true
      vim.opt.wrap = true
      vim.opt.cursorline = true
      vim.opt.scrolloff = 10
      vim.opt.signcolumn = "yes"
      vim.opt.splitright = true
      vim.opt.splitbelow = true
      vim.opt.list = true
      vim.opt.inccommand = "split"
      vim.opt.confirm = true
      vim.opt.foldmethod = "marker"
      vim.opt.tabstop = 2
      vim.opt.softtabstop = 2
      vim.opt.shiftwidth = 2
      vim.opt.expandtab = true
      vim.opt.breakindent = true
      vim.opt.undofile = true
      vim.opt.ignorecase = true
      vim.opt.smartcase = true
      vim.opt.updatetime = 250
      vim.opt.timeoutlen = 300
    '';

    luaConfigRC = {
      theme = builtins.readFile ./lua/theme.lua;
      miniConfig = builtins.readFile ./lua/mini.lua;
      commandAbbreviations = builtins.readFile ./lua/command-abbreviations.lua;
      telescopeConfig = builtins.readFile ./lua/telescope.lua;
      diagnosticsAndLsp = builtins.readFile ./lua/diagnostics-lsp.lua;
      quickfixAndAutocmds = builtins.readFile ./lua/quickfix-autocmds.lua;
      scriptsAndKeymaps = builtins.readFile ./lua/scripts-keymaps.lua;
      whichKeyGroups = builtins.readFile ./lua/which-key.lua;
    };
  };
}
