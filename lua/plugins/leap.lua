return {
  {
    "ggandor/flit.nvim",
    enabled = true,
    keys = function()
      local ret = {}
      --for _, key in ipairs({ "f", "F", "t", "T" }) do
      --  ret[#ret + 1] = { key, mode = { "n", "x", "o" } }
      --end
      return ret
    end,
  },
}
