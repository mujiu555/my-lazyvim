return {
  {
    "saghen/blink.cmp",
    opts = {
      completion = {
        list = { selection = { preselect = false, auto_insert = true } },
      },
      keymap = {
        preset = "enter",
        ["<Tab>"] = {
          function(cmp)
            if cmp.snippet_active() then
              cmp.hide()
              return cmp.snippet_forward()
            else
              return cmp.select_next()
            end
          end,
          "select_next",
          "snippet_forward",
          "fallback",
        },
        ["<S-Tab>"] = {
          function(cmp)
            if cmp.snippet_active() then
              cmp.hide()
              return cmp.snippet_backward()
            else
              return cmp.select_prev()
            end
          end,
          "select_prev",
          "snippet_backward",
          "fallback",
        },
        ["<Esc>"] = { "fallback", "cancel" },
        [">"] = { "scroll_documentation_up", "fallback" },
        ["<"] = { "scroll_documentation_down", "fallback" },
      },
    },
  },
}
