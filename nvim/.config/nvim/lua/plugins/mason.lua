return {
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "gopls",
        "goimports",
        "gofumpt",
        "golines",
        "delve",
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        gopls = {
          settings = {
            gopls = {
              gofumpt = true,
              codelenses = {
                generate = true,
                test = true,
                tidy = true,
              },
              hints = {
                assignVariableTypes = false,
                compositeLiteralFields = false,
                constantValues = false,
                parameterNames = false,
                rangeVariableTypes = false,
              },
            },
          },
        },
      },
      setup = {
        gopls = function(_, _)
          vim.api.nvim_create_autocmd("BufWritePost", {
            pattern = "*.go",
            callback = function()
              local root = vim.fn.getcwd()
              if vim.fn.filereadable(root .. "/go.mod") == 1 then
                vim.fn.jobstart("go mod tidy", {
                  cwd = root,
                  stdout_buffered = true,
                  stderr_buffered = true,
                })
              end
            end,
          })
        end,
      },
    },
  },
}
