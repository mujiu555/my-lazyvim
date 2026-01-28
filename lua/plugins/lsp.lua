return {
  {
    "neovim/nvim-lspconfig",
    config = {
      servers = {
        -- stylua = { mason = false },
        lua_ls = { mason = false },
        clangd = { mason = false },
        -- shfmt = { },
        texlab = { mason = false },
        bashls = { mason = false },
        jdtls = { mason = false },
        pyright = { mason = false },
        ruff = { mason = false },
        ["nil_ls"] = { mason = false },
        rust_analyzer = { mason = false },
        marksman = { mason = false },
        asmlsp = { mason = false },
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
