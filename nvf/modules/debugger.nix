{...}: {
  config.vim = {
    debugger.nvim-dap = {
      enable = true;
      ui = {
        enable = true;
        autoStart = true;
      };
      mappings = {
        continue = "<leader>dc";
        toggleBreakpoint = "<leader>db";
        toggleDapUI = "<leader>du";
        toggleRepl = "<leader>dr";
        hover = "<leader>dh";
        restart = "<leader>dR";
        runLast = "<leader>d.";
        runToCursor = "<leader>dl";
        stepInto = "<leader>di";
        stepOut = "<leader>do";
        stepOver = "<leader>dn";
        terminate = "<leader>dt";
        goDown = "<leader>dj";
        goUp = "<leader>dk";
      };
    };
  };
}
