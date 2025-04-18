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
      { "<leader>t", desc = "neotest" },
      { "<leader>tr", ':lua require("neotest").run.run()<CR>', { noremap = true, silent = true }, desc = "run test" },
      {
        "<leader>tf",
        ':lua require("neotest").run.run(vim.fn.expand("%"))<CR>',
        { noremap = true, silent = true },
        desc = "run tests in file",
      },
      { "<leader>tr", ':lua require("neotest").run.stop()<CR>', { noremap = true, silent = true }, desc = "stop test" },
      {
        "<leader>tp",
        ':lua require("neotest").output_panel.toggle()<CR>',
        { noremap = true, silent = true },
        desc = "output panel",
      },
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
