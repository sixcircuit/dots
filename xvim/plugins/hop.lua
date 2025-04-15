local hop = require('hop')
local hint = require('hop.hint')
local hint_dirs = hint.HintDirection
local hint_pos  = hint.HintPosition
local jump_regex = require('hop.jump_regex')
local jump_target = require("hop.jump_target")

hop.setup {
   x_bias = 100, -- show the letters spread over the x axis (line) first so it's like: a b c on a line
   -- keys = 'etovxqpdygfblzhckisuran',
   -- keys = 'asdfghjkl;qwertyuiopvbcnxmz,',
   keys = 'abcdefghijklmnopqrstuvwxyz;',
   -- keys = 'abcdefghijklmnopqrstuvwxyz;',
   jump_on_sole_occurrence = true,
   create_hl_autocmd = false,
}

local function escape_lua_pattern(str)
  return str:gsub("(%W)", "%%%1")
end

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

local function highlight_string_ends(hop_opts)
   hop_opts = hop_opts or {}

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

local function literal_regex(chars, hop_opts)
   return jump_regex.regex_by_case_searching(chars, true, hop_opts)
end

local function run_keys(keys)
   vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(keys, true, false, true), "n", true)
end

local function get_str_from_location(loc)
   local str = vim.api.nvim_buf_get_text(
     loc.buffer,
     loc.cursor.row-1, loc.cursor.col,
     loc.cursor.row-1, loc.cursor.col + loc.length, {}
   )
   return(str[1] or "")
end

local function clean_up_highlights(match_ids)
   for _, id in ipairs(match_ids) do
      vim.fn.matchdelete(id)
   end
end

local function highlight(regex_str, hop_opts)
   hop_opts = hop_opts or {}

   local bufnr = vim.api.nvim_get_current_buf()
   local win = vim.api.nvim_get_current_win()
   local cursor_row, cursor_col = unpack(vim.api.nvim_win_get_cursor(win))

   local match_ids = {}
   local regex = vim.regex(regex_str)

   local win_top = vim.fn.line("w0")
   local win_bottom = vim.fn.line("w$")
   local lines = vim.api.nvim_buf_get_lines(bufnr, win_top - 1, win_bottom, false)

   for i, line in ipairs(lines) do
      local line_num = win_top + i - 1

      -- Respect current_line_only
      if not hop_opts.current_line_only or line_num == cursor_row then
         local start = 1
         while start <= #line do
            local s, e = regex:match_str(line:sub(start))
            if not s then break end

            local col = start + s - 1
            local abs_row = line_num
            local abs_col = col

            -- Respect direction
            local is_after = abs_row > cursor_row or (abs_row == cursor_row and abs_col > cursor_col)
            local is_before = abs_row < cursor_row or (abs_row == cursor_row and abs_col < cursor_col)

            local should_include = true
            if hop_opts.direction == hint.HintDirection.AFTER_CURSOR and not is_after then
               should_include = false
            elseif hop_opts.direction == hint.HintDirection.BEFORE_CURSOR and not is_before then
               should_include = false
            end

            if should_include then
               local id = vim.fn.matchaddpos('HopMatchingPair', { { abs_row, abs_col + 1, e - s } })
               table.insert(match_ids, id)
            end

            start = start + e
         end
      end
   end

   return match_ids

end

local function hop_to_callback_f(opts, hop_opts, callback)
   opts = opts or {}
   return function(loc)
      if opts.jump ~= false then
         hop.move_cursor_to(loc, hop_opts)
      end

      if opts.cmd then
         local str = get_str_from_location(loc)
         local cmd = opts.cmd(str, loc)
         if cmd then run_keys(cmd) end
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

   local string_end_match_ids = highlight_string_ends(hop_opts)

   hop.hint_with_callback(jump_target_gtr, hop_opts, hop_to_callback_f(opts, hop_opts, callback))

   clean_up_highlights(string_end_match_ids)

end

hop_to.regex = function(regex_str, opts, hop_opts, callback)
   opts = merge(opts or {}, { offset = -1 })

   local match_ids

   if opts.highlight ~= nil then match_ids = highlight(opts.highlight, hop_opts) end

   local matcher

   if type(regex_str) == "table" then
      matcher = regex_str
   else
      local regex = vim.regex(regex_str)
      matcher = {
         oneshot = false,
         match = function(s)
            return regex:match_str(s)
         end,
      }
   end

   hop_opts = merge(hop.opts, hop_opts, { hint_offset = -(opts.offset) })

   local jump_target_gtr = jump_target.jump_target_generator(matcher)

   if opts.offset then
      local _jump_target_gtr = jump_target_gtr
      local offset = opts.offset or 0
      jump_target_gtr = function(_opts)
         local raw = _jump_target_gtr(_opts)
         for _, target in ipairs(raw.jump_targets) do
            target.cursor.col = target.cursor.col + offset
         end
         return raw
      end
   end

   hop.hint_with_callback(jump_target_gtr, hop_opts, hop_to_callback_f(opts, hop_opts, callback))

   if match_ids then clean_up_highlights(match_ids) end

end


-- hop_to.regex = function(regex_str, opts, hop_opts, callback)
--    opts = opts or {}
--
--    local match_ids
--
--    if opts.highlight ~= nil then match_ids = highlight(opts.highlight, hop_opts) end
--
--    hop_opts = merge(hop.opts, hop_opts)
--
--    local matcher
--
--    if type(regex_str) == "table" then
--       matcher = regex_str
--    else
--       local regex = vim.regex(regex_str)
--       matcher = {
--          oneshot = false,
--          match = function(s)
--             return regex:match_str(s)
--          end,
--       }
--    end
--
--    hop.hint_with_regex(matcher, hop_opts, hop_to_callback_f(opts, hop_opts, callback))
--
--    if match_ids then clean_up_highlights(match_ids) end
--
-- end
--
hop_to.chars = function(chars, opts, hop_opts, callback)
   assert(chars ~= nil)
   opts = opts or {}
   hop_opts = merge(hop.opts, hop_opts)
   local regex = literal_regex(chars, hop_opts)
   hop.hint_with_regex(regex, hop_opts, hop_to_callback_f(opts, hop_opts, callback))
end

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

local function wait_for_macro_finish(callback, interval)
   interval = interval or 10 -- ms
   local timer = vim.loop.new_timer()

   timer:start(0, interval, vim.schedule_wrap(function()
      local reg = vim.fn.reg_recording()
      if reg == "" then
         timer:stop()
         timer:close()
         callback()
      end
   end))
end

local function hop_change_ft(f_or_t, regex)
   assert(f_or_t == "f" or f_or_t == "t", "f_or_t must be 'f' or 't'")
   if regex == nil then
      local char = get_char()
      if char == nil then return nil end
      regex = jump_regex.regex_by_case_searching(char, true, hop.opts)
   end

   local win = vim.api.nvim_get_current_win()
   local buf = vim.api.nvim_get_current_buf()
   local start_row, start_col = unpack(vim.api.nvim_win_get_cursor(win))

   local hop_opts = merge(hop.opts, {
      direction = hint_dirs.AFTER_CURSOR,
      -- hint_position = hint_pos.BEGIN,
      current_line_only = true,
      -- hint_offset = 1
   })

   local change
   local matched

   local opts = {
      jump = false,
      cmd = function(matched_char, loc)
         matched = matched_char

         local line = vim.api.nvim_buf_get_lines(buf, start_row - 1, start_row, false)[1]

         local subline = line:sub(start_col + 1, loc.cursor.col + 1)
         local is_on_char = false
         if subline:sub(1,1) == matched_char then
            is_on_char = true
            subline = subline:sub(2)
         end
         local count = 0
         for _ in subline:gmatch(escape_lua_pattern(matched_char)) do
            count = count + 1
         end

         if count == 0 and is_on_char then
            if f_or_t == "f" then change = "xi" else change = "i" end
         else
            change = "c" .. count .. f_or_t .. matched_char
         end

         return change
      end
   }

   hop_to.regex(regex, opts, hop_opts, function()
      local recording_reg = vim.fn.reg_recording()
      if recording_reg == "" then return end
      wait_for_macro_finish(function()
         local current_macro = vim.fn.getreg(recording_reg)
         local updated_macro = current_macro:gsub("c[ft]q" .. escape_lua_pattern(matched), change, 1)
         vim.fn.setreg(recording_reg, updated_macro)
         -- print("recording_reg:", recording_reg)
         -- print("current_macro:", current_macro)
         -- print("updated_macro:", updated_macro)
      end)
   end)
end


vim.keymap.set('', 'mk', bind(hop_vertical_column, "up"))
vim.keymap.set('', 'mj', bind(hop_vertical_column, "down"))
vim.keymap.set('', '<leader>k', bind(hop_vertical_column, "up"))
vim.keymap.set('', '<leader>j', bind(hop_vertical_column, "down"))

vim.keymap.set('n', 'mm', '<cmd>HopChar1<cr>')
-- vim.keymap.set({ 'n', 'v' }, 'mc', "<cmd>HopChar1<cr>")

-- vim.keymap.set({ 'n', 'v' }, 'mw', "<cmd>HopWordAC<cr>")
-- vim.keymap.set({ 'n', 'v' }, 'mb', "<cmd>HopWordBC<cr>")
vim.keymap.set({ 'n', 'v' }, '<leader>w', "<cmd>HopWordAC<cr>")
vim.keymap.set({ 'n', 'v' }, '<leader>b', "<cmd>HopWordBC<cr>")

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

local function setup_moves(maps, prefix, moves)
   prefix = prefix or ""
   for _, item in pairs(moves) do
      if type(item) == "string" then
         vim.keymap.set(maps, prefix .. item, bind(hop_to.chars, item), { desc = "hop to " .. item })
      elseif type(item) == "table" then
         local cmd, desc, f_name, args = unpack(item)
         args = args or {}
         vim.keymap.set(maps, prefix .. cmd, bind(hop_to[f_name], unpack(args)), { desc = desc })
      end
   end
end

local any_pairs_regex = "[\\[\\]\\{\\}\\(\\)\"'`]"
local left_pairs_regex = "[\\[\\{\\(\"'`]"

 -- match all spaces that aren't at the start of a line
local spaces_regex = "\\S\\zs \\+"

local pair_args = {
   a = function(cmd, opts, hop_opts) opts = opts or {} return { "[\\[]", merge(opts, { highlight = "[\\]]", cmd = cmd, offset = -1 }), hop_opts } end,
   b = function(cmd, opts, hop_opts) opts = opts or {} return { "[{]",   merge(opts, { highlight = "[{}]", cmd = cmd, offset = -1 }), hop_opts   } end,
   p = function(cmd, opts, hop_opts) opts = opts or {} return { "[(]",   merge(opts, { highlight = "[()]", cmd = cmd, offset = -1 }), hop_opts   } end,
   q = function(cmd, opts, hop_opts) opts = opts or {} return { merge(opts, { cmd = cmd }), hop_opts } end
}

local function v_cmd(str) return "vi" .. str .. "" end
local function y_cmd(str) return "vi" .. str .. "y" end
local function p_cmd(str) return "vi" .. str .. "p`[" end
local function c_cmd(str) return "vi" .. str .. "c" end
local function i_cmd(str) return "i" end
local function a_cmd(str) return "a" end

local moves = {
   { "ta", "hop to []", "regex", pair_args.a() },
   { "tb", "hop to {}", "regex", pair_args.b() },
   { "tp", "hop to ()", "regex", pair_args.p() },
   { "q", "hop to quotes", "quotes" },
   { " ", "hop to spaces", "regex", { spaces_regex } },
   ")", "]", "}",
   ',', '.', ';', ':', "_", "-",
}

local edits = {

   -- { "va", "regex", pair_args.a(v_cmd) },
   -- { "vb", "regex", pair_args.b(v_cmd) },
   -- { "vp", "regex", pair_args.p(v_cmd) },
   -- { "vq", "quotes", pair_args.q(v_cmd) },

   { "ya", "yank inside []", "regex", pair_args.a(y_cmd) },
   { "yb", "yank inside {}", "regex", pair_args.b(y_cmd) },
   { "yp", "yank inside {}", "regex", pair_args.p(y_cmd) },
   { "yq", "yank inside quotes", "quotes", pair_args.q(y_cmd) },

   { "ca", "change inside []", "regex", pair_args.a(c_cmd) },
   { "cb", "change inside {}", "regex", pair_args.b(c_cmd) },
   { "cp", "change inside ()", "regex", pair_args.p(c_cmd) },
   { "cq", "change inside quotes", "quotes", pair_args.q(c_cmd) },

   { "pa", "paste inside []", "regex", pair_args.a(p_cmd) },
   { "pb", "paste inside {}", "regex", pair_args.b(p_cmd) },
   { "pp", "paste inside ()", "regex", pair_args.p(p_cmd) },
   { "pq", "paste inside quotes", "quotes", pair_args.q(p_cmd) },

}

setup_moves({ "n", "v" }, "m", moves)
setup_moves({ "n" }, "m", edits)

local on_line_after_cursor = {
   current_line_only = true,
   -- direction = hint_dirs.AFTER_CURSOR,
}

-- do inserts at all normal chars ,.-_, etc
local inserts = {
   { "iw", "insert at word", "regex", { jump_regex.regex_by_word_start(), { cmd = i_cmd } } },
   { "ia", "insert inside []", "regex", pair_args.a(a_cmd, nil, on_line_after_cursor) },
   { "ib", "insert inside {}", "regex", pair_args.b(a_cmd, nil, on_line_after_cursor) },
   { "ip", "insert inside ()", "regex", pair_args.p(a_cmd, nil, on_line_after_cursor) },
   { "iq", "insert inside quotes", "quotes", pair_args.q(a_cmd, nil, on_line_after_cursor) },
   { "i ", "insert at space", "regex", { spaces_regex, { cmd = i_cmd }, on_line_after_cursor } },
}

-- -- vim.keymap.set('n', 'i ', "f i", { desc = "insert at first space" })
-- vim.keymap.set('n', 'ia', "f[a", { desc = "insert at first [" })
-- vim.keymap.set('n', 'i[', "f[a", { desc = "insert at first [" })
-- vim.keymap.set('n', 'ib', "f{a", { desc = "insert at first {" })
-- vim.keymap.set('n', 'i{', "f{a", { desc = "insert at first {" })
-- vim.keymap.set('n', 'ip', "f(a", { desc = "insert at first (" })
-- vim.keymap.set('n', 'i(', "f(a", { desc = "insert at first (" })
-- vim.keymap.set('n', 'i]', "f]a", { desc = "insert at first ]" })
-- vim.keymap.set('n', 'i}', "f}a", { desc = "insert at first }" })
-- vim.keymap.set('n', 'ii]', "t]a", { desc = "insert at first ]" })
-- vim.keymap.set('n', 'ii}', "t}a", { desc = "insert at first }" })
-- vim.keymap.set('n', 'ii)', "t)a", { desc = "insert at first )" })
-- vim.keymap.set('n', 'i)', "f)a", { desc = "insert at first )" })
-- vim.keymap.set('n', 'i.', "f.a", { desc = "insert at first ." })
-- vim.keymap.set('n', 'i_', "f_a", { desc = "insert at first _" })
-- vim.keymap.set('n', 'i=', "f=a", { desc = "insert at first =" })
-- vim.keymap.set('n', 'i:', "f:a", { desc = "insert at first :" })
-- vim.keymap.set('n', 'i<', "f<a", { desc = "insert at first <" })
-- vim.keymap.set('n', 'i>', "f>a", { desc = "insert at first >" })
--
-- vim.keymap.set('n', 'iq', function()
--    local line = vim.fn.getline('.')
--    local col = vim.fn.col('.')
--    local after_cursor = string.sub(line, col)
--    local offset = vim.fn.match(after_cursor, "[\"'`]")
--
--    if offset >= 0 then
--       vim.fn.cursor(vim.fn.line('.'), col + offset + 1)
--       vim.cmd('startinsert')
--    end
-- end, { silent = true,  desc = "insert at first quote" })
--
-- vim.keymap.set('n', 'i ', function()
--    local line = vim.fn.getline('.')
--    local col = vim.fn.col('.')
--
--    local first_nonspace_col = string.find(line, '%S') or 1
--    local effective_start = math.max(col, first_nonspace_col)
--
--    local search_start = vim.fn.strpart(line, effective_start - 1)
--    local offset = string.find(search_start, ' ')
--
--    if offset then
--       vim.fn.cursor(vim.fn.line('.'), effective_start + offset - 1)
--       vim.cmd('startinsert')
--    end
-- end, { noremap = true, silent = true, desc = "insert at first non-leading space" })

setup_moves({ "n" }, "", inserts)


vim.keymap.set('', 'cfq', bind(hop_change_ft, "f", "[\"'`]"))
vim.keymap.set('', 'ctq', bind(hop_change_ft, "t", "[\"'`]"))
vim.keymap.set('', 'cf ', bind(hop_change_ft, "f", spaces_regex))
vim.keymap.set('', 'ct ', bind(hop_change_ft, "t", spaces_regex))
-- vim.keymap.set('', 'cfv', bind(hop_change_ft, "f", jump_regex.regex_by_camel_case()))
-- vim.keymap.set('', 'ctv', bind(hop_change_ft, "t", jump_regex.regex_by_camel_case()))
vim.keymap.set('', 'cf', bind(hop_change_ft, "t"))
vim.keymap.set('', 'ct', bind(hop_change_ft, "t"))

-- linewise repeatable
-- cmv -- (variable) camel case move forward
-- ---@param opts Options
-- function M.hint_camel_case(opts)
--   local jump_regex = require('hop.jump_regex')
--
--   opts = override_opts(opts)
--   opts = {
--       direction = dirs.AFTER_CURSOR,
--       current_line_only = true
--    }
--   M.hint_with_regex(jump_regex.regex_by_camel_case(), opts)
-- end

vim.keymap.set('n', 'mpm', "<cmd>HopPasteChar1<cr>")
-- vim.keymap.set('n', 'mym', "<cmd>HopYankChar1<cr>")



-- This part is the important one for `ct`, `dt`, etc.
vim.keymap.set('o', 'm', function()
  hop.hint_char1({
    -- direction = dirs.AFTER_CURSOR,
    -- current_line_only = true,
  })
end, { remap = true })

-- vim.keymap.set('o', 'M', function()
--   hop.hint_char1({
--     -- direction = dirs.BEFORE_CURSOR,
--     -- current_line_only = true,
--   })
-- end, { remap = true })

