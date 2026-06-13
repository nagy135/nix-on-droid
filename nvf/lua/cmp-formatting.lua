require("conform").setup({
	notify_on_error = false,
	format_on_save = function(bufnr)
		local disable_filetypes = { c = true, cpp = true }
		local lsp_format_opt = disable_filetypes[vim.bo[bufnr].filetype] and "never" or "fallback"
		return {
			timeout_ms = 500,
			lsp_format = lsp_format_opt,
		}
	end,
	formatters_by_ft = {
		lua = { "stylua" },
		python = { "isort", "black" },
		typescript = { "prettierd", stop_after_first = true },
		typescriptreact = { "prettierd", stop_after_first = true },
		javascript = { "prettierd", stop_after_first = true },
		javascriptreact = { "prettierd", stop_after_first = true },
	},
})

local lint = require("lint")
lint.linters_by_ft.markdown = nil
lint.linters_by_ft.rst = nil
-- lint.linters_by_ft.typescript = nil
-- lint.linters_by_ft.typescriptreact = nil
lint.linters_by_ft.text = nil
