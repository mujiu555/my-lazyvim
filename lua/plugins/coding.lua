return {
  {
    "saghen/blink.cmp",
    opts = {
      completion = {
        list = { selection = { preselect = false, auto_insert = true } },
      },
      keymap = {
        preset = "enter",
        ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
        ["<S-Tab>"] = { "select_prev", "snippet_forward", "fallback" },
        ["<Esc>"] = { "fallback", "cancel" },
        [">"] = { "scroll_documentation_up", "fallback" },
        ["<"] = { "scroll_documentation_down", "fallback" },
      },
    },
  },
}
