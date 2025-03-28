return {
  "akinsho/bufferline.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  version = "*",
  opts = { -- tells lazy to run require(bufferline).setup(opts)
    options = {
      mode = "tabs", 
      separator_style = "slant",
    },
  },
}
