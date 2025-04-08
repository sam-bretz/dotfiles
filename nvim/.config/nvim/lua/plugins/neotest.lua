return {
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-neotest/neotest-python",
      "nvim-neotest/neotest-go",
      "nvim-neotest/nvim-nio",
    },
    keys = {
      { "<leader>tn", ':lua require("neotest").run.run()<CR>', { noremap = true, silent = true } },
      { "<leader>tf", ':lua require("neotest").run.run(vim.fn.expand("%"))<CR>', { noremap = true, silent = true } },
      { "<leader>to", ':lua require("neotest").output.open()<CR>', { noremap = true, silent = true } },
      { "<leader>tp", ':lua require("neotest").output_panel.toggle()<CR>', { noremap = true, silent = true } },
      { "<leader>ts", ':lua require("neotest").summary.toggle()<CR>', { noremap = true, silent = true } },
    },

    config = function()
      require("neotest").setup({
        adapters = {
          require("neotest-python")({
            -- Additional configurations can be added here
          }),
          require("neotest-go")({
            -- Additional configurations can be added here
          }),
        },
      })
    end,
  },
}
