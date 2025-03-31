return {
    "nvim-telescope/telescope.nvim",

    tag = "0.1.5",

    dependencies = {
      "nvim-lua/plenary.nvim",
    },

    config = function()
      require('telescope').setup({})

      local keymap = vim.keymap
      local builtin = require('telescope.builtin')

      keymap.set('n', '<leader>pf', builtin.find_files, { desc = "Fuzzy find files in cwd" })

      keymap.set("n", "<leader>pr", builtin.oldfiles, { desc = "Fuzzy find recent files" })
      keymap.set("n", "<leader>ps", builtin.live_grep, { desc = "Find string in cwd" })

      keymap.set("n", "<leader>ps", builtin.grep_string, { desc = "Find string under cursor in cwd" })
      --keymap.set('n', '<leader>ps', function()
      --    builtin.grep_string({ search = vim.fn.input("Grep > ") })
      --end)

      keymap.set('n', '<C-p>', builtin.git_files, { desc = "Fuzzy find only git files" })
      keymap.set('n', '<leader>ph', builtin.help_tags, { desc = "List available help tags" })


    end
}
