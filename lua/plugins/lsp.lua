return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        ["*"] = { mason = false, enable = false },
        zls = { mason = false, enable = true },
      },
    },
  },
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {},
    },
  },
}
