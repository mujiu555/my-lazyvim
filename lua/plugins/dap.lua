return {
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      for i, pkg in ipairs(opts.ensure_installed) do
        if pkg == "codelldb" then
          table.remove(opts.ensure_installed, i)
          break
        end
      end
    end,
  },
}
