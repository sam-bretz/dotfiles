return {
  "theprimeagen/harpoon",
  keys = {
    {
      "<leader>ha",
      function()
        require("harpoon.mark").add_file()
      end,
      desc = "Harpoon: Add file",
    },
    {
      "<leader>hh",
      function()
        require("harpoon.ui").toggle_quick_menu()
      end,
      desc = "Harpoon: Toggle menu",
    },
    {
      "<leader>hq",
      function()
        require("harpoon.ui").nav_file(1)
      end,
      desc = "Harpoon: Nav file 1",
    },
    {
      "<leader>hw",
      function()
        require("harpoon.ui").nav_file(2)
      end,
      desc = "Harpoon: Nav file 2",
    },
    {
      "<leader>he",
      function()
        require("harpoon.ui").nav_file(3)
      end,
      desc = "Harpoon: Nav file 3",
    },
    {
      "<leader>hr",
      function()
        require("harpoon.ui").nav_file(4)
      end,
      desc = "Harpoon: Nav file 4",
    },
  },
}
