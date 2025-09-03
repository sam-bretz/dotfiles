return {
  "stevearc/conform.nvim",
  optional = true,
  opts = function()
    local opts = {
      -- Define your formatters
      formatters_by_ft = {
        lua = { "stylua" },
        sh = { "shfmt" },
        go = { "goimports", "gofumpt" },
        python = { "isort", "black" },
        javascript = { "prettier" },
        typescript = { "prettier" },
        json = { "prettier" },
        yaml = { "prettier" },
        markdown = { "prettier" },
      },
      -- Customize formatters
      formatters = {
        shfmt = {
          prepend_args = { "-i", "2" },
        },
      },
    }
    return opts
  end,
}