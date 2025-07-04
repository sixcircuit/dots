local hop = require('hop')
local hint = require('hop.hint')
local hint_dirs = hint.HintDirection
local hint_pos  = hint.HintPosition
local jump_regex = require('hop.jump_regex')
local jump_target = require("hop.jump_target")

hop.setup {
   x_bias = 100, -- show the letters spread over the x axis (line) first so it's like: a b c on a line
   keys = 'abcdefghijklmnopqrstuvwxyz',
   jump_on_sole_occurrence = true,
   create_hl_autocmd = false,
   uppercase_labels = true,
   teasing = false,
   -- hint_position = hint_pos.MIDDLE,
   -- keys = 'etovxqpdygfblzhckisuran',
   -- keys = 'asdfghjkl;qwertyuiopvbcnxmz,',
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

local function get_char(prompt)
   prompt = prompt or "char? "

   -- Show the prompt in the command area
   vim.api.nvim_echo({{prompt, "Question"}}, false, {})

   local ok, char = pcall(vim.fn.getchar)
   vim.api.nvim_echo({{""}}, false, {}) -- clear prompt

   if not ok then return nil end

   -- handle numbers and char types
   if type(char) == "number" then
      return vim.fn.nr2char(char)
   end
   return char
end

-- local function get_char()
--    local ok, char = pcall(vim.fn.getchar)
--    if not ok then return nil end
--
--    -- handle numbers and char types
--    if type(char) == "number" then
--       return vim.fn.nr2char(char)
--    end
--    return char
-- end

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
      if opts.precmd then
         local str = get_str_from_location(loc)
         local cmd = opts.precmd(str, loc)
         if cmd then run_keys(cmd) end
      end

      if opts.prehook then
         loc = opts.prehook(loc)
      end

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

-- hop_to.quotes = function(opts, hop_opts, callback)
--    local lang = vim.bo.filetype
--    local parser = vim.treesitter.get_parser(0, lang)
--    if not parser then return end
--
--    local function jump_target_gtr()
--
--       local tree = parser:parse()[1]
--       local root = tree:root()
--       local jump_targets = {}
--
--       local win_top = vim.fn.line("w0")
--       local win_bottom = vim.fn.line("w$")
--
--       traverse_tree(root, function(n)
--          local type = n:type()
--          if type == "string" or type == "template_string" then
--             local row, col = n:start()
--             local line = row + 1
--             if line >= win_top and line <= win_bottom then
--                table.insert(jump_targets, {
--                   window = vim.api.nvim_get_current_win(),
--                   buffer = vim.api.nvim_get_current_buf(),
--                   cursor = {
--                      row = row + 1,
--                      col = col,
--                   },
--                   length = 1
--                })
--             end
--          end
--       end)
--       return { jump_targets = jump_targets }
--    end
--
--    hop_opts = merge(hop.opts, { hint_offset = 0 })
--
--    local string_end_match_ids = highlight_string_ends(hop_opts)
--
--    hop.hint_with_callback(jump_target_gtr, hop_opts, hop_to_callback_f(opts, hop_opts, callback))
--
--    clean_up_highlights(string_end_match_ids)
--
-- end

hop_to.regex = function(regex_str, opts, hop_opts, callback)
   opts = merge(opts or {}, { offset = 0 })

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

   if opts.hook then
      local _jump_target_gtr = jump_target_gtr
      local offset = opts.offset or 0
      jump_target_gtr = function(_opts)
         local raw = _jump_target_gtr(_opts)
         vim.print(raw)
         raw.indirect_jump_targets = nil
         raw.jump_targets = opts.hook(raw.jump_targets)
         return raw
      end
   end

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


hop_to.chars = function(chars, opts, hop_opts, callback)
   opts = opts or {}
   hop_opts = merge(hop.opts, hop_opts)

   if chars == nil then
      chars = get_char()
      if chars == nil then return nil end
   end

   local regex = literal_regex(chars, hop_opts)
   hop.hint_with_regex(regex, hop_opts, hop_to_callback_f(opts, hop_opts, callback))
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

local function hop_ft(f_or_t, action, regex)
   assert(f_or_t == "f" or f_or_t == "t", "f_or_t must be 'f' or 't'")
   assert(
     ({ i = true, a = true, c = true, d = true })[action],
     'action must be "i", "a", "c", or "d"'
   )

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
      hook = function(targets)
         local res = {}
         for _, target in ipairs(targets) do
            if target.cursor.col ~= start_col then
               table.insert(res, target)
            end
         end
         return res
      end,
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
            -- this is how vim works by default.
            return ""
            -- if f_or_t == "f" then change = "xi" else change = "i" end
         else
            if action == "i" or action == "a" then
               change = count .. f_or_t .. matched_char .. action
            else
               change = action .. count .. f_or_t .. matched_char
            end
         end

         return change
      end
   }

   hop_to.regex(regex, opts, hop_opts, function()
      -- TODO: support macros somehow. or turn off during macros
      -- local recording_reg = vim.fn.reg_recording()
      -- if recording_reg == "" then return end
      -- wait_for_macro_finish(function()
      --    local current_macro = vim.fn.getreg(recording_reg)
      --    local updated_macro = current_macro:gsub("[cd][ft]q" .. escape_lua_pattern(matched), change, 1)
      --    vim.fn.setreg(recording_reg, updated_macro)
      --    -- print("recording_reg:", recording_reg)
      --    -- print("current_macro:", current_macro)
      --    -- print("updated_macro:", updated_macro)
      -- end)
   end)
end

vim.keymap.set('', '<space>k', "mk", { remap = true })
vim.keymap.set('', '<space>j', "mj", { remap = true })
-- vim.keymap.set('', ';w', "mk", { remap = true })
-- vim.keymap.set('', ';b', "mj", { remap = true })

-- vim.keymap.set('n', 'ml', '<cmd>HopChar1<cr>')
-- vim.keymap.set({ 'n', 'v' }, 'mc', "<cmd>HopChar1<cr>")

-- vim.keymap.set({ 'n', 'v' }, ';w', "<cmd>HopWordAC<cr>")
-- vim.keymap.set({ 'n', 'v' }, 'mw', "<cmd>HopWordAC<cr>")
-- vim.keymap.set({ 'n', 'v' }, 'mb', "<cmd>HopWordBC<cr>")
-- vim.keymap.set({ 'n', 'v' }, '<leader>w', "<cmd>HopWordAC<cr>")
-- vim.keymap.set({ 'n', 'v' }, '<leader>b', "<cmd>HopWordBC<cr>")

-- vim.keymap.set({ 'n', 'v' }, '<leader>j', "<cmd>HopLineAC<cr>")
-- vim.keymap.set({ 'n', 'v' }, '<leader>k', "<cmd>HopLineBC<cr>")

-- vim.keymap.set('n', 'mlw', "<cmd>HopWordCurrentLineAC<cr>")
-- vim.keymap.set('n', 'mlc', "<cmd>HopChar1CurrentLineAC<cr>")
-- vim.keymap.set('n', 'mla', "<cmd>HopAnywhereCurrentLineAC<cr>")
-- vim.keymap.set('n', 'mll', "<cmd>HopAnywhereCurrentLineAC<cr>")
-- vim.keymap.set('n', 'mls', "<cmd>HopCamelCaseCurrentLineAC<cr>")

-- vim.keymap.set('n', 'mv', "<cmd>HopCamelCase<cr>")
-- vim.keymap.set('n', 'mms', "<cmd>HopCamelCase<cr>")

-- vim.keymap.set('n', 'm/', "<cmd>HopPatternAC<cr>")
-- vim.keymap.set('n', 'm?', "<cmd>HopPatternBC<cr>")

local last_hop_f = nil

local function setup_hops(maps, prefix, moves, opts, hopts)
   opts = opts or {}
   hopts = hopts or {}
   prefix = prefix or ""
   for _, item in pairs(moves) do
      assert(type(item) == "table", "item must be a table")
      local setup = item.setup
      local hop_f = bind(hop_to[setup.hop_f], setup.matcher, merge(opts, setup.opts), merge(hopts, setup.hopts))
      local hop_f_repatable = function() last_hop_f = hop_f; hop_f() end
      -- vim.print(item)
      vim.keymap.set(maps, prefix .. item.keys, hop_f_repatable, { desc = item.desc })
   end
end

vim.keymap.set({ 'n' }, "mm", function() if last_hop_f then last_hop_f() end end, { desc = "repeat the last hop command." })

-- local any_pairs_regex = "[\\[\\]\\{\\}\\(\\)\"'`]"
-- local left_pairs_regex = "[\\[\\{\\(\"'`]"

local function open_or_close(str, loc)
   if str == "(" then return ("open") end
   if str == "{" then return ("open") end
   if str == "[" then return ("open") end
   if str == "<" then return ("open") end
   if str == ")" then return ("close") end
   if str == "}" then return ("close") end
   if str == "]" then return ("close") end
   if str == ">" then return ("close") end

   if str ~= "'" and str ~= "`" and str ~= '"' then
      vim.notify("you passed a string we didn't expect. this only works with bracket pairs and quotes", vim.log.levels.WARN)
      return("")
   end

   local line = vim.api.nvim_buf_get_lines(0, loc.cursor.row - 1, loc.cursor.row, false)[1]
   local quote_positions = {}
   local quote = str

   -- find all quotes of the same kind on the line
   for i = 1, #line do
      if line:sub(i, i) == quote then
         table.insert(quote_positions, i)
      end
   end

   local quote_index = nil
   for i, pos in ipairs(quote_positions) do
      if pos == loc.cursor.col + 1 then  -- loc.cursor.col is 0-indexed
         quote_index = i
         break
      end
   end

   if not quote_index then
      vim.notify("could not find quote index", vim.log.levels.WARN)
      return ""
   end

   -- odd = opening, insert inside (after the quote)
   -- even = closing, append before the quote
   if quote_index % 2 == 1 then return "open" else return "close" end
end


local function is_empty_pair(str, loc)

   local pairs = {
      ["{"] = "}", ["("] = ")", ["["] = "]", ["<"] = ">",
      ["}"] = "{", [")"] = "(", ["]"] = "[", [">"] = "<",
   }

   local quotes = {
      ['"'] = '"', ["'"] = "'", ["`"] = "`",
   }


   local line = vim.api.nvim_buf_get_lines(0, loc.cursor.row - 1, loc.cursor.row, false)[1]
   local col = loc.cursor.col
   local kind = open_or_close(str, loc)

   local pair = pairs[str]
   local quote = quotes[str]

   local char_before = line:sub(col, col)
   local char_after = line:sub(col + 2, col + 2)

   if pair then
      if kind == "open" and char_after == pair then return true end
      if kind == "close" and char_before == pair then return true end
      return false
   elseif quote then
      if kind == "open" and char_after == quote then return true end
      if kind == "close" and char_before == quote then return true end
      return false
   else
      return(nil)
   end

end


local cmds = {
   i = function(str) return "i" end,
   a = function(str) return "a" end,
   o = function(str) return "o" end,
   v = function(str)
      vim.cmd("normal! v")
      return nil  -- prevent fallback key feeding
   end,
   V = function(str)
      vim.cmd("normal! V")
      return nil  -- prevent fallback key feeding
   end,
   x = function(str) return "x" end,
   s = function(str) return "s" end,
   dot = function(str) return "." end,
   star = function(str) return "*" end,
   vi = function(str) return "vi" .. str .. "" end,
   yi = function(str) return "yi" .. str .. "" end,
   y = function(str) return "y" end,
   ya = function(str) return "ya" .. str .. "" end,
   ci = function(str) return "vi" .. str .. "c" end,
   cw = function(str) return "cw" end,
   dw = function(str) return "dw" end,
   ciw = function(str) return "ciw" end,
   diw = function(str) return "diwx<left>" end,
   ciW = function(str) return "ciW" end,
   diW = function(str) return "diWx" end,
   P = function(str, loc) return "P`[" end,
   p = function(str, loc) return "p`[" end,
   ps = function(str, loc) return "a <esc>p`[" end,
   pi = function(str, loc)
      local is_empty = is_empty_pair(str, loc)
      if is_empty == nil then return end
      if is_empty then return "p`["
      else return "vi" .. str .. "p`[" end
   end,
}

cmds.p_linewise = function ()
   local text = vim.fn.getreg("", 1, true)
   vim.api.nvim_put(text, "l", true, true)
   return("`[")
end

cmds.pp = function(str, loc)
   local result = open_or_close(str, loc)
   if result == "open" then return("p")
   elseif result == "close" then return("P")
   else return("") end
end

cmds.ii = function(str, loc)
   local result = open_or_close(str, loc)
   if result == "open" then return("a")
   elseif result == "close" then return("i")
   else return("") end
end

cmds.io = function(str, loc)
   local result = open_or_close(str, loc)
   if result == "open" then return("i")
   elseif result == "close" then return("a")
   else return("") end
end

local function _setup(f_name, matcher, opts, hopts)
   return({
      hop_f = f_name,
      matcher = matcher,
      opts = opts,
      hopts = hopts
   })
end

local function _setup_f(f_name, matcher, _opts, _hopts)
   return function(opts, hopts)
      opts = merge(_opts or {}, opts or {})
      hopts = merge(_hopts or {}, hopts or {})
      return _setup(f_name, matcher, opts, hopts)
   end
end

 -- match all spaces that aren't at the start of a line
local spaces_regex = "\\S\\zs \\+"
-- local  = jump_regex.regex_by_camel_case()
local variable_regex = "_"

local _setups = {
   x = _setup_f("regex", "[[\\]]", { highlight = "[[\\]]" }),
   b = _setup_f("regex", "[{}]",   { highlight = "[{}]" }),
   p = _setup_f("regex", "[()]",   { highlight = "[()]" }),
   g = _setup_f("regex", "[<>]",   { highlight = "[<>]" }),
   q = _setup_f("regex", "[\"'`]"),
   s = _setup_f("regex", "[!\"#$%&'()*+,-./:;<=>?@[\\]^_`{|}~]"),
   [" "] = _setup_f("regex", spaces_regex),
   -- sa = _setup_f("regex", "[\\[]", { highlight = "[\\]]" }),
   -- sb = _setup_f("regex", "[{]",   { highlight = "[{}]" }),
   -- sp = _setup_f("regex", "[(]",   { highlight = "[()]" }),
   -- ea = _setup_f("regex", "[\\]]", { highlight = "[\\]]" }),
   -- eb = _setup_f("regex", "[}]",   { highlight = "[{}]" }),
   -- ep = _setup_f("regex", "[)]",   { highlight = "[()]" }),
   w = _setup_f("regex", jump_regex.regex_by_word_start()),
   W = _setup_f("regex",  [[\S\+]]),
   v = _setup_f("regex", variable_regex),
   -- sw = _setup_f("regex", jump_regex.regex_by_word_start()),
   -- ew = _setup_f("regex", jump_regex.regex_by_word_end())
}

local vertical_matcher = {
   oneshot = true,
   match = function(s, jctx, opts)
      local win = vim.api.nvim_get_current_win()
      local cursor_row, cursor_col = unpack(vim.api.nvim_win_get_cursor(win))

      if not opts.current and jctx.line_ctx.row == cursor_row then return end

      local type = opts.vertical or "start"

      local target_col = cursor_col

      if type == "start" then
         target_col = (s:find("%S") or 1) - 1
      elseif type == "end" then
         target_col = #s-1
      elseif type == "column" then
         target_col = cursor_col
      end

      if -1 < target_col and target_col < #s then
         return target_col, target_col + 1
      else
         return 0, 1
      end
   end,
}


_setups.k = _setup_f("regex", vertical_matcher, {}, { direction = hint_dirs.BEFORE_CURSOR })
_setups.j = _setup_f("regex", vertical_matcher, {}, { direction = hint_dirs.AFTER_CURSOR })


local doubles = {
   x = "[]", b = "{}", p = "()", q = "quotes", g = "<>"
}
-- local doubles_start = { sa = "[", sb = "{", sp = "(", sq = "quotes", sw = "word start" }
-- local doubles_end = { ea = "]", eb = "}", ep = ")", eq = "quotes", ew = "word end" }

local singles = {
   [" "] = "spaces",
   w = "word",
   s = "symbols",
   W = "Word",
   v = "variable name",
   j = "line start down",
   k = "line start up",
}

local function add_chars(tbl, chars) for _, char in pairs(chars) do tbl[char] = char end end

add_chars(singles, {
   "'", '"', "`",
   "(" ,")", "[", "]", "{", "}", "<", ">",
   ',', '.', ';', ':', "_", "-", "=", "/", "\\"
})

local function h(keys, desc, setup)
   return { keys = keys, desc = desc, setup = setup }
end

local function add(tbl, map, keys_prefix, desc_prefix, opts, hopts)
   map = map or {}

   for key, desc in pairs(map) do
      -- vim.print("key:", key)
      -- vim.print("desc:", desc)

      local setup = { hop_f = "chars", matcher = key, opts = opts, hopts = hopts }

      if type(desc) == "table" then
         setup = merge(setup, desc)
         desc = setup.desc
      elseif _setups[key] then
         setup = _setups[key](opts, hopts)
      end

      table.insert(tbl, h(keys_prefix .. key, desc_prefix .. " " .. desc, setup))
   end

end

local moves = {}

add(moves, doubles, "", "hop to")
add(moves, singles, "" , "hop to")
add(moves, singles, "t", "hop to")
add(moves, doubles, "t", "hop to")

add(moves, { k = "line up" }, "", "hop to", { }, {
   vertical = "column",
   direction = hint_dirs.BEFORE_CURSOR,
   keys = "kabcdefghijlmnopqrstuvwxyz",
})

add(moves, { j = "line down" }, "", "hop to", { }, {
   vertical = "column",
   direction = hint_dirs.AFTER_CURSOR,
   keys = "jabcdefghiklmnopqrstuvwxyz",
})

local dots = {}

add(dots, singles, ".", "dot repeat at", { cmd = cmds.dot })
add(dots, doubles, ".", "dot repeat at", { cmd = cmds.dot })

local yanks = {}

add(yanks, doubles, "", "yank inside",   { cmd = cmds.yi })
add(yanks, doubles, "a", "yank a",   { cmd = cmds.ya })

add(yanks, singles, "", "yank till", { precmd = cmds.v, cmd = cmds.y })

add(yanks, { k = "line up" }, "", "yank till line", {
   precmd = cmds.v,
   cmd = cmds.y,
   prehook = function (loc)
      loc.cursor.col = 0
      return(loc)
   end
})

add(yanks, { j = "line down" }, "", "yank till line", {
   precmd = cmds.v,
   cmd = cmds.y,
   prehook = function (loc)
      local line = vim.api.nvim_buf_get_lines(0, loc.cursor.row - 1, loc.cursor.row, false)[1]
      loc.cursor.col = #line
      return(loc)
   end
})

local changes = {}

add(changes, doubles, "c", "change inside", { cmd = cmds.ci })
add(changes, { w = "word" }, "c", "change a", { cmd = cmds.ciw })
add(changes, { w = "word" }, "d", "delete a", { cmd = cmds.diw })
add(changes, { s = "symbol" }, "c", "change a", { cmd = cmds.ciw })
add(changes, { s = "symbol" }, "d", "delete a", { cmd = cmds.diw })
add(changes, { W = "Word" }, "c", "change a", { cmd = cmds.ciW })
add(changes, { W = "Word" }, "d", "delete a", { cmd = cmds.diW })
add(changes, { l = "" }, "d", "delete magic on this line", { cmd = cmds.diW })

local pastes = {}
add(pastes, doubles, "p", "paste at",  { cmd = cmds.pp })
add(pastes, doubles, "pi", "paste inside",  { cmd = cmds.pi })
add(pastes, singles, "p", "paste at",  { cmd = cmds.p })
add(pastes, { [" "] = "spaces" }, "p", "paste at",  { cmd = cmds.p })

add(pastes, { k = "line up" }, "p", "hop to", { cmd = cmds.p_linewise }, {
   -- current = true, -- this doesn't really make sense moving up
   -- vertical = "column",
   direction = hint_dirs.BEFORE_CURSOR,
   -- keys = "kabcdefghijlmnopqrstuvwxyz",
})

add(pastes, { j = "line down" }, "p", "hop to", { cmd = cmds.p_linewise }, {
   current = true,
   -- vertical = "column",
   direction = hint_dirs.AFTER_CURSOR,
   -- keys = "jabcdefghiklmnopqrstuvwxyz",
})
-- add(pastes, singles, "ps", "paste space at",  { cmd = cmds.ps })
-- add(pastes, { [" "] = "spaces" }, "ps", "paste space at",  { cmd = cmds.ps })

local line_only = {
   current_line_only = true,
   -- direction = hint_dirs.AFTER_CURSOR,
}

local inserts = {}

add(inserts, singles, "i", "insert at", { cmd = cmds.i })
add(inserts, doubles, "i", "insert at", { cmd = cmds.ii })

add(inserts, singles, "a", "append at", { cmd = cmds.a })
-- add(inserts, doubles, "a", "append at", { cmd = cmds.a })
-- you want aa for append eventually
-- this does the same thing as io<x,b,p,q>
-- add(inserts, doubles, "a", "append at", { cmd = cmds.io })

-- add(inserts, singles, "is", "insert at start", { cmd = cmds.i })
-- add(inserts, singles, "ie", "insert at end", { cmd = cmds.a })

add(inserts, { k = "line up" }, "a", "append at end of line", { cmd = cmds.a }, { vertical = "end" })
add(inserts, { j = "line down" }, "a", "append at end of line", { cmd = cmds.a }, { vertical = "end" })

add(inserts, doubles, "io", "insert outside", { cmd = cmds.io })
-- you want ii for insert eventually
-- and this is the same thing as i<x,b,p,q>
-- add(inserts, doubles, "ii", "insert inside", { cmd = cmds.ii })

setup_hops({ "n", "v" }, "m", moves)
setup_hops({ "n", "v" }, "", {
   h("m", "move to char", _setup("chars", nil, {})),
   h("m ", "move to space", _setup("regex", spaces_regex, {})),
   h("mc", "move to char", _setup("chars", nil, {})),
   h("mv", "move to variable", _setup("regex", variable_regex, {})),
})

setup_hops({ "n" }, "m", dots)
setup_hops({ "n" }, "", {
   h("m.", "repeat at char", _setup("chars", nil, { cmd = cmds.dot })),
   h("m.c", "repeat at char", _setup("chars", nil, { cmd = cmds.dot })),
   h("m.v", "repeat at variable", _setup("regex", variable_regex, { cmd = cmds.dot })),
   h("m*", "* a word", _setups.w({ cmd = cmds.star })),
})

-- setup_hops({ "n" }, "m", changes, nil, line_only)
setup_hops({ "n" }, "", changes)
setup_hops({ "n" }, "", {
   h("dc", "delete a char", _setup("chars", nil, { cmd = cmds.x })),
   h("d ", "delete a space", _setup("regex", spaces_regex, { cmd = cmds.x })),
   h("cc", "change a char", _setup("chars", nil, { cmd = cmds.s })),
   h("cv", "chage a variable", _setup("regex", variable_regex, { cmd = function () return("<right>cw") end })),
   h("dv", "delete a variable", _setup("regex", variable_regex, { cmd = cmds.dw })),
})

-- setup_hops({ "n" }, "m", yanks, nil, line_only)
setup_hops({ "n" }, "y", yanks)
setup_hops({ "n" }, "y", {
   h("", "yank to char", _setup("chars", nil, { precmd = cmds.v, cmd = cmds.y })),
   h("c", "yank to char", _setup("chars", nil, { precmd = cmds.v, cmd = cmds.y })),
})

setup_hops({ "n" }, "", pastes)
setup_hops({ "n" }, "", {
   h("p", "paste at char", _setup("chars", nil, { cmd = cmds.p })),
   h("pc", "paste at char", _setup("chars", nil, { cmd = cmds.p })),
   -- h("pk", "paste at line", _setup("regex", jump_regex.by_line_start(), { cmd = cmds.p }, { direction = hint_dirs.BEFORE_CURSOR })),
   -- h("pj", "paste at line", _setup("regex", jump_regex.by_line_start(), { cmd = cmds.p }, { direction = hint_dirs.AFTER_CURSOR })),
   h("pe", "paste at line end", _setup("regex", "$", { cmd = cmds.p })),
   h("pl", "paste at line", _setup("regex", jump_regex.by_line_start(), { cmd = cmds.P })),
})

-- setup_hops({ "n" }, "m", inserts, nil, line_only)
setup_hops({ "n" }, "", inserts)
setup_hops({ "n" }, "", {
   h("i", "insert at char", _setup("chars", nil, { cmd = cmds.i })),
   h("a", "append at char", _setup("chars", nil, { cmd = cmds.a })),
   h("ic", "insert at char", _setup("chars", nil, { cmd = cmds.i })),
   h("ac", "append at char", _setup("chars", nil, { cmd = cmds.a })),
   h("iv", "insert at variable", _setup("regex", variable_regex, { cmd = cmds.i })),
   h("av", "append at variable", _setup("regex", variable_regex, { cmd = cmds.a })),
})

_setups.k = _setup_f("regex", vertical_matcher, {}, { direction = hint_dirs.BEFORE_CURSOR })
_setups.j = _setup_f("regex", vertical_matcher, {}, { direction = hint_dirs.AFTER_CURSOR })

setup_hops({ "n" }, "", {
   h("ok", "o at line", _setup("regex", vertical_matcher, { cmd = cmds.o }, { direction = hint_dirs.BEFORE_CURSOR })),
   h("oj", "o at line", _setup("regex", vertical_matcher, { cmd = cmds.o }, { direction = hint_dirs.AFTER_CURSOR }))
})

-- vim.keymap.set('n', 'mp', "<cmd>HopPasteChar1<cr>")
-- vim.keymap.set('n', 'mpl', "<cmd>HopPasteChar1<cr>")
-- vim.keymap.set('n', 'mym', "<cmd>HopYankChar1<cr>")

vim.keymap.set('n', 'yy', 'yy')
vim.keymap.set('n', 'yiw', 'yiw')

local magic_regex = "[\\[\\]{}()<>\"'` ]"

vim.keymap.set('n', 'ii', bind(hop_ft, "f", "i", magic_regex), { desc = "insert magic" })
vim.keymap.set('n', 'aa', bind(hop_ft, "f", "a", magic_regex), { desc = "append magic" })
vim.keymap.set('n', 'cc', bind(hop_ft, "f", "c", magic_regex), { desc = "change magic" })
vim.keymap.set('n', 'dl', bind(hop_ft, "f", "d", magic_regex), { desc = "delete magic" })

vim.keymap.set('n', 'cfx', bind(hop_ft, "f", "c", "[\\[\\]]"))
vim.keymap.set('n', 'ctx', bind(hop_ft, "t", "c", "[\\[\\]]"))
vim.keymap.set('n', 'cfb', bind(hop_ft, "f", "c", "[{}]"))
vim.keymap.set('n', 'ctb', bind(hop_ft, "t", "c", "[{}]"))
vim.keymap.set('n', 'cfp', bind(hop_ft, "f", "c", "[()]"))
vim.keymap.set('n', 'ctp', bind(hop_ft, "t", "c", "[()]"))
vim.keymap.set('n', 'cfg', bind(hop_ft, "f", "c", "[<>]"))
vim.keymap.set('n', 'ctg', bind(hop_ft, "t", "c", "[<>]"))
vim.keymap.set('n', 'cfq', bind(hop_ft, "f", "c", "[\"'`]"))
vim.keymap.set('n', 'ctq', bind(hop_ft, "t", "c", "[\"'`]"))
vim.keymap.set('n', 'cf ', bind(hop_ft, "f", "c", spaces_regex))
vim.keymap.set('n', 'ct ', bind(hop_ft, "t", "c", spaces_regex))
vim.keymap.set('n', 'cf',  bind(hop_ft, "f", "c"))
vim.keymap.set('n', 'ct',  bind(hop_ft, "t", "c"))
vim.keymap.set('n', 'cfc', bind(hop_ft, "f", "c"))
vim.keymap.set('n', 'ctc', bind(hop_ft, "t", "c"))

vim.keymap.set('n', 'dfx', bind(hop_ft, "f", "d", "[\\[\\]]"))
vim.keymap.set('n', 'dtx', bind(hop_ft, "t", "d", "[\\[\\]]"))
vim.keymap.set('n', 'dfb', bind(hop_ft, "f", "d", "[{}]"))
vim.keymap.set('n', 'dtb', bind(hop_ft, "t", "d", "[{}]"))
vim.keymap.set('n', 'dfp', bind(hop_ft, "f", "d", "[()]"))
vim.keymap.set('n', 'dtp', bind(hop_ft, "t", "d", "[()]"))
vim.keymap.set('n', 'dfg', bind(hop_ft, "f", "d", "[<>]"))
vim.keymap.set('n', 'dtg', bind(hop_ft, "t", "d", "[<>]"))
vim.keymap.set('n', 'dfq', bind(hop_ft, "f", "d", "[\"'`]"))
vim.keymap.set('n', 'dtq', bind(hop_ft, "t", "d", "[\"'`]"))
vim.keymap.set('n', 'df ', bind(hop_ft, "f", "d", spaces_regex))
vim.keymap.set('n', 'dt ', bind(hop_ft, "t", "d", spaces_regex))
vim.keymap.set('n', 'df',  bind(hop_ft, "f", "d"))
vim.keymap.set('n', 'dt',  bind(hop_ft, "t", "d"))
vim.keymap.set('n', 'dfc', bind(hop_ft, "f", "d"))
vim.keymap.set('n', 'dtc', bind(hop_ft, "t", "d"))

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
local function visual_move()
   local hops = { current = true }
   hop_to.regex(vertical_matcher, {}, hops, function(loc)
      if not loc then return end
      local timer = vim.loop.new_timer()
      timer:start(10, 0, vim.schedule_wrap(function()
         -- run_keys("V")
         hop_to.regex(vertical_matcher, { precmd = cmds.V }, hops)
      end))
   end)
end

vim.keymap.set('n', "mv", visual_move)
vim.keymap.set('n', "vm", visual_move)
vim.keymap.set('n', "sw", "m*", { remap = true, desc = "hop * a word" })


-- -- This part is the important one for `ct`, `dt`, etc.
-- vim.keymap.set('o', 'm', function()
--   hop.hint_char1({
--     -- direction = dirs.AFTER_CURSOR,
--     -- current_line_only = true,
--   })
-- end, { remap = true })

-- vim.keymap.set('o', 'M', function()
--   hop.hint_char1({
--     -- direction = dirs.BEFORE_CURSOR,
--     -- current_line_only = true,
--   })
-- end, { remap = true })

-- vim.keymap.set('n', 'i ', "f i", { desc = "insert at first space" })
-- vim.keymap.set('n', 'ik', "f[a", { desc = "insert at first [" })
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
--
-- TODO: write a callback handler for hop that passes quit state through. if we do that this vertical hack might work
-- local function get_viewport_lines()
--    local win_top = vim.fn.line("w0")
--    local win_bottom = vim.fn.line("w$")
--    local lines = {}
--    for i = win_top, win_bottom do table.insert(lines, i) end
--    return lines
-- end
--
-- -- Pads real lines with spaces and returns a cleanup map
-- local function pad_lines_physically(bufnr, cursor_col)
--    local edits = {}
--    local lines_to_restore = {}
--
--    for _, lnum in ipairs(get_viewport_lines()) do
--       local line = vim.api.nvim_buf_get_lines(bufnr, lnum - 1, lnum, false)[1] or ""
--       local len = vim.fn.strdisplaywidth(line)
--
--       if len < cursor_col then
--          local padding = string.rep(" ", cursor_col - len)
--          table.insert(edits, { lnum = lnum, orig = line })
--          vim.api.nvim_buf_set_lines(bufnr, lnum - 1, lnum, false, { line .. padding })
--       end
--    end
--
--    return edits
-- end
--
-- -- Restore original lines after hop
-- local function restore_lines(bufnr, edits)
--    for _, e in ipairs(edits) do
--       vim.api.nvim_buf_set_lines(bufnr, e.lnum - 1, e.lnum, false, { e.orig })
--    end
-- end
--
--
-- hop_to.vertical_column_physical = function(opts, hop_opts, callback)
--    local win = vim.api.nvim_get_current_win()
--    local buf = vim.api.nvim_get_current_buf()
--    local cursor_row, cursor_col = unpack(vim.api.nvim_win_get_cursor(win))
--
--    -- Save and disable trailing whitespace visibility
--    local list_was_on = vim.wo[win].list
--    local listchars_backup = vim.o.listchars
--    vim.wo[win].list = false
--    vim.o.listchars = ""
--
--    -- Pad lines
--    local edits = pad_lines_physically(buf, cursor_col)
--
--    local function jump_target_gtr()
--       local jump_targets = {}
--       for _, line in ipairs(get_viewport_lines()) do
--          local is_valid = true
--          if opts and opts.direction == hint.HintDirection.BEFORE_CURSOR and line >= cursor_row then
--             is_valid = false
--          elseif opts and opts.direction == hint.HintDirection.AFTER_CURSOR and line <= cursor_row then
--             is_valid = false
--          end
--          if is_valid then
--             table.insert(jump_targets, {
--                window = win,
--                buffer = buf,
--                cursor = { row = line, col = cursor_col },
--                length = 1,
--             })
--          end
--       end
--       return { jump_targets = jump_targets }
--    end
--
--    hop_opts = merge(hop.opts, hop_opts or {}, { hint_offset = 0 })
--
--    local cleaned_up = false
--    local function clean()
--       if cleaned_up then return end
--       restore_lines(buf, edits)
--       vim.wo[win].list = list_was_on
--       vim.o.listchars = listchars_backup
--       cleaned_up = true
--    end
--
--    -- Wrap hint_with_callback to ensure cleanup on cancel
--    local ok = pcall(function()
--       hop.hint_with_callback(jump_target_gtr, hop_opts, function(loc)
--          clean()
--          hop_to_callback_f(opts, hop_opts, callback)(loc)
--       end)
--    end)
--
--    if not ok then
--       -- Esc or error: clean up anyway
--       vim.schedule(clean)
--    end
-- end
-- vim.keymap.set("n", "<leader>v", function()
--    hop_to.vertical_column_physical()
-- end, { desc = "Hop vertically with padded lines" })
--
-- vim.keymap.set("n", "<leader>j", function()
--    hop_to.vertical_column_physical({ direction = hint.HintDirection.AFTER_CURSOR })
-- end, { desc = "Hop down vertically" })
--
-- vim.keymap.set("n", "<leader>k", function()
--    hop_to.vertical_column_physical({ direction = hint.HintDirection.BEFORE_CURSOR })
-- end, { desc = "Hop up vertically" })


