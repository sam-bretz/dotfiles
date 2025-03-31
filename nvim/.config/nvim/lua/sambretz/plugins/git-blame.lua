return {
    "f-person/git-blame.nvim",
    config = function()
        vim.keymap.set("n", "<leader>ur", vim.cmd.GitBlameOpenCommitURL)
    end

--:GitBlameOpenCommitURL
}
