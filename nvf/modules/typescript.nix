{...}: {
  config.vim = {
    languages.typescript = {
      enable = true;
      lsp.servers = ["typescript-go"];
      extensions = {
        # "ts-error-translator" = {
        #   enable = true;
        #   setupOpts = {
        #     auto_attach = true;
        #     auto_override_publish_diagnostics = false;
        #     servers = [ "tsgo" ];
        #   };
        # };
      };
    };

    lsp.servers.typescript-go.filetypes = [
      "typescript"
      "javascript"
      "typescriptreact"
      "javascriptreact"
    ];
  };
}
