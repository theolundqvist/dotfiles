local options = {
  formatters_by_ft = {
    lua = { "stylua" },
    css = { "prettier" },
    html = { "prettier" },
    js = { "prettier" },
    jsx = { "prettier" },
    ts = { "eslint" },
    tsx = { "eslint" },
    go = { "gofmt" },
    wsgi = { "black" },
    py = { "black" }
  },

  format_on_save = {
    -- These options will be passed to conform.format()
    timeout_ms = 500,
    lsp_fallback = true,
  },
}

require("conform").setup(options)
