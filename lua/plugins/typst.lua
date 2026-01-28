return {
  {
    "chomosuke/typst-preview.nvim",
    opts = {
      dependencies_bin = {
        ["tinymist"] = "tinymist",
        ["websocat"] = "websocat",
      },
    },
    -- lazy.nvim will implicitly calls `setup {}`
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        ---@type vim.lsp.Config
        tinymist = {
          mason = false,
          root_markers = { ".git", ".typsite" },
        },
      },
    },
  },
}
