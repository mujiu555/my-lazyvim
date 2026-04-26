local term_command_created = false

---@return string
local function root_dir()
  return LazyVim.root()
end

---@class term_entry
---@field id integer
---@field title string

---@param id integer
---@param create? boolean
---@return snacks.win? terminal
local function get_root_terminal(id, create)
  return Snacks.terminal.get(nil, {
    cwd = root_dir(),
    count = id,
    create = create,
  })
end

---@return term_entry[]
local function list_root_terminal_entries()
  local root = root_dir()
  local entries = {} ---@type term_entry[]
  local seen = {} ---@type table<integer, boolean>
  for _, term in ipairs(Snacks.terminal.list()) do
    local ok, data = pcall(function()
      return vim.b[term.buf].snacks_terminal
    end)
    if ok and data and data.cwd == root and data.cmd == nil then
      local id = tonumber(data.id)
      if id and not seen[id] then
        seen[id] = true
        local title = ""
        local ok_title, term_title = pcall(function()
          return vim.b[term.buf].term_title
        end)
        if ok_title and type(term_title) == "string" then
          title = vim.trim(term_title)
        end
        entries[#entries + 1] = { id = id, title = title }
      end
    end
  end
  table.sort(entries, function(a, b)
    return a.id < b.id
  end)
  return entries
end

---@return integer[]
local function list_root_terminal_ids()
  return vim.tbl_map(function(entry)
    return entry.id
  end, list_root_terminal_entries())
end

---@return integer
local function next_root_terminal_id()
  local ids = list_root_terminal_ids()
  local next_id = 1
  for _, id in ipairs(ids) do
    if id == next_id then
      next_id = next_id + 1
    elseif id > next_id then
      break
    end
  end
  return next_id
end

---@param s string
---@return integer?
local function parse_id(s)
  local n = tonumber(s)
  if not n or n < 1 or math.floor(n) ~= n then
    return nil
  end
  return n
end

---@param action string
---@param raw_args string
---@return integer?
local function get_action_id(action, raw_args)
  raw_args = raw_args or ""
  local target = raw_args:match("^%s*" .. action .. "%s+(.+)$") or ""
  local id_str = target:match("^%s*(%d+)")
  return id_str and parse_id(id_str) or nil
end

---@param s string
---@return string
local function escape_completion_item(s)
  return vim.fn.escape(s, " \\")
end

---@param arg_lead string
---@return string[]
local function complete_terminal_target(arg_lead)
  local items = {} ---@type string[]
  local seen = {} ---@type table<string, boolean>

  for _, entry in ipairs(list_root_terminal_entries()) do
    local item = tostring(entry.id)
    if entry.title ~= "" then
      item = ("%d %s"):format(entry.id, entry.title)
    end
    item = escape_completion_item(item)
    if not seen[item] then
      seen[item] = true
      items[#items + 1] = item
    end
  end

  return vim.tbl_filter(function(item)
    return item:find("^" .. vim.pesc(arg_lead))
  end, items)
end

---@param args string[]
---@param raw_args string
local function term_command(args, raw_args)
  raw_args = raw_args or ""
  local action = args[1]
  if action == "new" then
    local id = next_root_terminal_id()
    local cmd = raw_args:match("^%s*new%s+(.+)$")
    Snacks.terminal.focus(cmd, { cwd = root_dir(), count = id })
    LazyVim.info(("Terminal %d opened"):format(id), { title = "Term" })
    return
  end

  if action == "switch" then
    local id = get_action_id("switch", raw_args)
    if not id then
      return LazyVim.error("Usage: :Term switch <id>", { title = "Term" })
    end
    Snacks.terminal.focus(nil, { cwd = root_dir(), count = id })
    return
  end

  if action == "delete" then
    local id = get_action_id("delete", raw_args)
    if not id then
      return LazyVim.error("Usage: :Term delete <id>", { title = "Term" })
    end
    local term = get_root_terminal(id, false)
    if not (term and term:buf_valid()) then
      return LazyVim.warn(("Terminal %d not found"):format(id), { title = "Term" })
    end
    vim.api.nvim_buf_delete(term.buf, { force = true })
    return
  end

  local usage = {
    "Usage: :Term new [cmd] | :Term <switch|delete> <id>",
    "Examples:",
    "  :Term new",
    "  :Term new htop",
    "  :Term switch 2",
    "  :Term delete 2",
  }
  return LazyVim.info(usage, { title = "Term" })
end

local function setup_term_command()
  -- If user command is registed, skip
  if term_command_created or vim.fn.exists(":Term") == 2 then
    term_command_created = true
    return
  end

  -- If Snacks.terminal is not available, skip
  if not Snacks or not Snacks.terminal then
    LazyVim.warn("Snacks.terminal is not available, skipping :Term command", { title = "Term" })
    return
  end

  vim.api.nvim_create_user_command("Term", function(opts)
    term_command(opts.fargs, opts.args)
  end, {
    nargs = "*",
    complete = function(arg_lead, cmd_line)
      if cmd_line:match("^%s*%S+%s+switch%s+") or cmd_line:match("^%s*%S+%s+delete%s+") then
        return complete_terminal_target(arg_lead)
      end
      if cmd_line:match("^%s*%S+%s*%S*$") then
        return vim.tbl_filter(function(item)
          return item:find("^" .. vim.pesc(arg_lead))
        end, { "new", "switch", "delete" })
      end
      return {}
    end,
    desc = "Manage numbered root terminals with Snacks.terminal",
  })

  term_command_created = true
end

return {
  {
    "snacks.nvim",
    optional = true,
    init = function()
      LazyVim.on_load("snacks.nvim", setup_term_command)
    end,
  },
}
