-- https://github.com/neovim/nvim-lspconfig

-- Ensure nvim-lspconfig is installed
local lspconfig = require('lspconfig')

-- Common on_attach function to define keybindings after LSP attaches to buffer
local on_attach = function(client, bufnr)
  local buf_set_keymap = vim.api.nvim_buf_set_keymap
  local opts = { noremap=true, silent=true }

  -- Example keybindings
  buf_set_keymap(bufnr, 'n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap(bufnr, 'n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
  -- Add more keybindings as needed
end

-- Enable gopls for Go
lspconfig.gopls.setup {
  on_attach = on_attach,
  -- Additional gopls settings
}

-- Enable tsserver for TypeScript and React
lspconfig.tsserver.setup {
  on_attach = on_attach,
  filetypes = { "typescript", "typescriptreact", "typescript.tsx" },
  cmd = { "typescript-language-server", "--stdio" }
}

-- Enable yaml-language-server for YAML
lspconfig.yamlls.setup {
  on_attach = on_attach,
  -- Additional yaml-language-server settings
}



