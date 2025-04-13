local hop = require('hop')
local directions = require('hop.hint').HintDirection
local jump_regex = require('hop.jump_regex')

hop.setup {
   x_bias = 100, -- show the letters spread over the x axis (line) first so it's like: a b c on a line
   -- keys = 'etovxqpdygfblzhckisuran',
   -- keys = 'asdfghjkl;qwertyuiopvbcnxmz,',
   keys = 'abcdefghijklmnopqrstuvwxyz;',
   -- keys = 'abcdefghijklmnopqrstuvwxyz;',
   jump_on_sole_occurrence = true,
   create_hl_autocmd = false,
}

local function move_char_to_front(str, char)
   local modified = str:gsub(char, "", 1) -- remove first occurrence
   return char .. modified
end

local function merge(base, ...)
   local result = {}
   for k, v in pairs(base) do
      result[k] = v
   end
   for _, override in ipairs({ ... }) do
      for k, v in pairs(override) do
         result[k] = v
      end
   end
   return setmetatable(result, getmetatable(base))
end

local function bind(func, ...)
  local args = { ... }
  return function()
    return func(unpack(args))
  end
end

local function reverse(tbl)
   local result = {}
   for i = #tbl, 1, -1 do
      result[#result + 1] = tbl[i]
   end
   return result
end

local function get_char()
  local ok, char = pcall(vim.fn.getchar)
  if not ok then return nil end

  -- handle numbers and char types
  if type(char) == "number" then
    return vim.fn.nr2char(char)
  end
  return char
end

local function traverse_tree(node, callback)
   if not node then return end
   callback(node)
   for child in node:iter_children() do
      traverse_tree(child, callback)
   end
end

local hop_to = {}

local function highlight_string_ends()
   local bufnr = vim.api.nvim_get_current_buf()
   local parser = vim.treesitter.get_parser(bufnr, vim.bo.filetype)
   if not parser then return end

   local tree = parser:parse()[1]
   local root = tree:root()

   local ns = vim.api.nvim_create_namespace("string_end_highlight")
   vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)

   local string_end_match_ids = {}

   local win_top = vim.fn.line("w0")
   local win_bottom = vim.fn.line("w$")

   traverse_tree(root, function(node)
      local type = node:type()
      if type == "string" or type == "template_string" then

         local end_row, end_col = node:end_()
         local line_num = end_row + 1

         if line_num >= win_top and line_num <= win_bottom then
            local line = vim.api.nvim_buf_get_lines(bufnr, end_row, end_row + 1, false)[1]
            if line and end_col > 0 then
               local id = vim.fn.matchaddpos('HopMatchingQuote', { { end_row + 1, end_col, 1 } })
               table.insert(string_end_match_ids, id)
               -- vim.api.nvim_buf_add_highlight(bufnr, ns, 'HopMatchingPair', end_row, end_col - 1, end_col)
            end
         end
      end
   end)

   return string_end_match_ids

end

local function run_keys(keys)
   vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(keys, true, false, true), "n", false)
end

local function get_str_from_location(loc)
   local str = vim.api.nvim_buf_get_text(
     loc.buffer,
     loc.cursor.row-1, loc.cursor.col,
     loc.cursor.row-1, loc.cursor.col + loc.length, {}
   )
   return(str[1] or "")
end

local function hop_to_callback_f(opts, hop_opts, callback)
   vim.print(opts)
   opts = opts or {}
   return function(loc)
      print("here")
      if opts.jump ~= false then
         hop.move_cursor_to(loc, hop_opts)
      end

      if opts.cmd then
         vim.print(loc)
         local str = get_str_from_location(loc)
         vim.print(str)
         run_keys(opts.cmd(str))
      end

      if callback then
         callback(loc)
      end
   end
end

hop_to.quotes = function(opts, hop_opts, callback)
   local lang = vim.bo.filetype
   local parser = vim.treesitter.get_parser(0, lang)
   if not parser then return end

   local function jump_target_gtr()

      local tree = parser:parse()[1]
      local root = tree:root()
      local hint_positions = {}

      local win_top = vim.fn.line("w0")
      local win_bottom = vim.fn.line("w$")

      traverse_tree(root, function(n)
         local type = n:type()
         if type == "string" or type == "template_string" then
            local row, col = n:start()
            local line = row + 1
            if line >= win_top and line <= win_bottom then
               table.insert(hint_positions, {
                  window = vim.api.nvim_get_current_win(),
                  buffer = vim.api.nvim_get_current_buf(),
                  cursor = {
                     row = row + 1,
                     col = col,
                  },
                  length = 1
               })
            end
         end
      end)
      return { jump_targets = hint_positions }
   end

   hop_opts = merge(hop.opts, { hint_offset = 0 })

   local string_end_match_ids = highlight_string_ends()

   hop.hint_with_callback(jump_target_gtr, hop_opts, hop_to_callback_f(opts, hop_opts, callback))

   for _, id in ipairs(string_end_match_ids) do
     vim.fn.matchdelete(id)
   end

end

hop_to.regex = function(regex_str, opts, hop_opts, callback)
   if opts == nil then
      opts = {}
   end

   local match_id

   if opts.highlight ~= nil then
      match_id = vim.fn.matchadd('HopMatchingPair', opts.highlight)
   end

   hop_opts = merge(hop.opts, hop_opts)

   local regex = vim.regex(regex_str)

   hop.hint_with_regex({
      oneshot = false,
      match = function(s)
         return regex:match_str(s)
      end,
   }, hop_opts, hop_to_callback_f(opts, hop_opts, callback))

   if match_id ~= nil then
      vim.fn.matchdelete(match_id)
   end

end

hop_to.chars = function(chars, opts)
   assert(chars ~= nil)
   opts = merge(hop.opts, opts)
   hop.hint_with_regex(jump_regex.regex_by_case_searching(chars, false, opts), opts)
end

-- this is the new code
-- local function hop_change_char()
--   local hop = require('hop')
--   local hint = require('hop.hint')
--
--   -- Get current position
--   local win = vim.api.nvim_get_current_win()
--   local buf = vim.api.nvim_get_current_buf()
--   local start_row, start_col = unpack(vim.api.nvim_win_get_cursor(win))
--
--   hop.hint_char1({
--     hint_position = hint.HintPosition.BEGIN,
--     direction = hint.HintDirection.AFTER_CURSOR,
--     callback = function(target)
--       local end_row = target.cursor.row
--       local end_col = target.cursor.col
--
--       -- Only support single-line changes for now
--       if end_row ~= start_row then
--         vim.notify("Only single-line targets are supported", vim.log.levels.WARN)
--         return
--       end
--
--       -- Get the line content
--       local line = vim.api.nvim_buf_get_lines(buf, start_row - 1, start_row, false)[1]
--       local target_char = line:sub(end_col, end_col)
--
--       -- Calculate distance to target
--       local count = end_col - start_col
--
--       if count <= 0 then
--         vim.notify("Target must be after the cursor", vim.log.levels.WARN)
--         return
--       end
--
--       -- Construct repeatable motion: `c{count}f<char>`
--       vim.cmd("normal! c" .. count .. "f" .. target_char)
--     end,
--   })
-- end

-- vim.keymap.set("n", "<leader>cc", hop_change_char, {
--   desc = "Hop and construct repeatable change (cNfX)",
-- })

local function hop_vertical_column(dir)
   local col = vim.fn.col('.') - 1
   local cursor_row = vim.fn.line(".")
   local win_top = vim.fn.line("w0")
   local win_bottom = vim.fn.line("w$")

   local start_row, end_row
   if dir == "down" then
      start_row = cursor_row + 1
      end_row = win_bottom
   else
      start_row = win_top
      end_row = cursor_row - 1
   end

   local lines = vim.api.nvim_buf_get_lines(0, start_row - 1, end_row, false)

   if dir == "up" then lines = reverse(lines) end

   local function jump_target_gtr()
      local hint_positions = {}

      for i, line in ipairs(lines) do
         local row = (dir == "down") and (start_row + i - 1) or (end_row - i + 1)
         local target_col = col

         if #line < col + 1 then target_col = #line end

         table.insert(hint_positions, {
            window = vim.api.nvim_get_current_win(),
            buffer = vim.api.nvim_get_current_buf(),
            cursor = {
               row = row,
               col = target_col,
            },
            length = 1,
         })
      end

      return { jump_targets = hint_positions }
   end

   local opts = merge(hop.opts, { hint_offset = 0 })

   local close_char = "j"
   if dir == "up" then close_char = "k" end

   opts.keys = move_char_to_front(opts.keys, close_char)

   -- TODO: needs hint_with_callback
   hop.hint_with(jump_target_gtr, opts)
end

-- linewise repeatable
-- cmv -- (variable) camel case move forward

vim.keymap.set('', 'mk', bind(hop_vertical_column, "up"))
vim.keymap.set('', 'mj', bind(hop_vertical_column, "down"))
vim.keymap.set('', '<leader>k', bind(hop_vertical_column, "up"))
vim.keymap.set('', '<leader>j', bind(hop_vertical_column, "down"))

vim.keymap.set('n', 'mm', '<cmd>HopChar1<cr>')
vim.keymap.set({ 'n', 'v' }, 'mc', "<cmd>HopChar1<cr>")

vim.keymap.set({ 'n', 'v' }, 'mw', "<cmd>HopWord<cr>")

-- vim.keymap.set({ 'n', 'v' }, '<leader>w', "<cmd>HopWordAC<cr>")
-- vim.keymap.set({ 'n', 'v' }, '<leader>b', "<cmd>HopWordBC<cr>")
-- vim.keymap.set({ 'n', 'v' }, '<leader>j', "<cmd>HopLineAC<cr>")
-- vim.keymap.set({ 'n', 'v' }, '<leader>k', "<cmd>HopLineBC<cr>")

-- vim.keymap.set('n', 'mlw', "<cmd>HopWordCurrentLineAC<cr>")
-- vim.keymap.set('n', 'mlc', "<cmd>HopChar1CurrentLineAC<cr>")
-- vim.keymap.set('n', 'mla', "<cmd>HopAnywhereCurrentLineAC<cr>")
-- vim.keymap.set('n', 'mll', "<cmd>HopAnywhereCurrentLineAC<cr>")
-- vim.keymap.set('n', 'mls', "<cmd>HopCamelCaseCurrentLineAC<cr>")

-- vim.keymap.set('n', 'ms', "<cmd>HopCamelCaseCurrentLine<cr>")
-- vim.keymap.set('n', 'mms', "<cmd>HopCamelCase<cr>")

-- vim.keymap.set('n', 'm/', "<cmd>HopPatternAC<cr>")
-- vim.keymap.set('n', 'm?', "<cmd>HopPatternBC<cr>")

-- vim.keymap.set('n', 'mpc', "<cmd>HopPasteChar1<cr>")

local function setup_moves(maps, moves)
   for _, item in pairs(moves) do
      if type(item) == "string" then
         vim.keymap.set(maps, "m"  .. item, bind(hop_to.chars, item))
      elseif type(item) == "table" then
         local cmd, f_name, args = unpack(item)
         args = args or {}
         vim.keymap.set(maps, "m"  .. cmd, bind(hop_to[f_name], unpack(args)))
      end
   end
end

local any_pairs_regex = "[\\[\\]\\{\\}\\(\\)\"'`]"
local left_pairs_regex = "[\\[\\{\\(\"'`]"

local pair_args = {
   a = function(cmd, opts) opts = opts or {} return { "[\\[]", merge(opts, { highlight = "[\\]]", cmd = cmd }) } end,
   b = function(cmd, opts) opts = opts or {} return { "[{]",   merge(opts, { highlight = "[}]", cmd = cmd })   } end,
   p = function(cmd, opts) opts = opts or {} return { "[(]",   merge(opts, { highlight = "[)]", cmd = cmd })   } end,
   q = function(cmd, opts) opts = opts or {} return { merge(opts, { cmd = cmd }) } end
}

local function v_cmd(str) return "vi" .. str .. "" end
local function y_cmd(str) return "vi" .. str .. "y" end
local function p_cmd(str) return "vi" .. str .. "p" end
local function c_cmd(str) return "vi" .. str .. "c" end
local function i_cmd(str) return "a" end

local moves = {
   { "a", "regex", pair_args.a() },
   { "b", "regex", pair_args.b() },
   { "p", "regex", pair_args.p() },
   { "q", "quotes" },
   { " ", "regex", { "\\S\\zs \\+" } }, -- match all spaces that aren't at the start of a line
   ',', '.', ';', ':', "_", "-",
}

local edits = {

   -- { "va", "regex", pair_args.a(v_cmd) },
   -- { "vb", "regex", pair_args.b(v_cmd) },
   -- { "vp", "regex", pair_args.p(v_cmd) },
   -- { "vq", "quotes", pair_args.q(v_cmd) },

   { "ya", "regex", pair_args.a(y_cmd) },
   { "yb", "regex", pair_args.b(y_cmd) },
   { "yp", "regex", pair_args.p(y_cmd) },
   { "yq", "quotes", pair_args.q(y_cmd) },

   { "ca", "regex", pair_args.a(c_cmd) },
   { "cb", "regex", pair_args.b(c_cmd) },
   { "cp", "regex", pair_args.p(c_cmd) },
   { "cq", "quotes", pair_args.q(c_cmd) },

   { "da", "regex", pair_args.a(p_cmd) },
   { "db", "regex", pair_args.b(p_cmd) },
   { "dp", "regex", pair_args.p(p_cmd) },
   { "dq", "quotes", pair_args.q(p_cmd) },

   { "ia", "regex", pair_args.a(i_cmd) },
   { "ib", "regex", pair_args.b(i_cmd) },
   { "ip", "regex", pair_args.p(i_cmd) },
   { "iq", "quotes", pair_args.q(i_cmd) },
}

setup_moves({ "n", "v" }, moves)
setup_moves({ "n" }, edits)



-- This part is the important one for `ct`, `dt`, etc.
vim.keymap.set('o', 'm', function()
  hop.hint_char1({
    -- direction = directions.AFTER_CURSOR,
    -- current_line_only = true,
  })
end, { remap = true })

-- vim.keymap.set('o', 'M', function()
--   hop.hint_char1({
--     -- direction = directions.BEFORE_CURSOR,
--     -- current_line_only = true,
--   })
-- end, { remap = true })

