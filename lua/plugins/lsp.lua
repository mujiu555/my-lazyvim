return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        ["*"] = {
          mason = false,
          enabled = false,
        },
        codelldb = {
          mason = false,
          enabled = false,
        },
        shfmt = {
          mason = false,
          enabled = false,
        },
        clangd = {
          mason = false,
          enabled = true,
        },
        zls = {
          mason = false,
          enabled = true,
        },
        vue_ls = { -- volar
          mason = false,
          enabled = true,
          hybridMode = false,
        },
        vtsls = {
          mason = false,
        },
        lua_ls = {
          mason = false,
          enabled = true,
        },
        nil_ls = {
          mason = false,
          enabled = true,
        },
        ruff = {
          mason = false,
        },
        marksman = {
          mason = false,
        },
        pyright = {
          mason = false,
        },
        stylua = {
          mason = false,
          enabled = true,
        },
      },
    },
  },
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = {}
    end,
  },
}
