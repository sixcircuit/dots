
local function bind(func, ...)
   local args = { ... }
   return function()
      return func(unpack(args))
   end
end

local function fuzzy_search()
   vim.g.fuzzysearch_prompt = 'fz/'
   -- local status, err = pcall(vim.fn['fuzzysearch#start_search'])
   local status, _ = pcall(vim.fn['fuzzysearch#start_search'])
   if not status then
      vim.print("")
   end
end

local function rg_and_open_first(type)
   local search_term

   if type == "rgw" then
      search_term = vim.fn.expand("<cword>")
   else
      local ok
      ok, search_term = pcall(vim.fn.input, type .. '/')
      if not ok then search_term = "" end
   end

   if search_term == '' then return end

   -- Open a new tab
   vim.cmd('tabnew')

   -- One-time autocmd to jump when quickfix is populated
   vim.api.nvim_create_autocmd("QuickFixCmdPost", {
      pattern = "caddexpr",
      once = true,
      callback = function()
         local qf = vim.fn.getqflist()
         if #qf > 0 then
            vim.defer_fn(function()
               vim.cmd("cc 1")
            end, 10)
         else
            vim.notify("No results found in quickfix", vim.log.levels.WARN)
         end
      end,
   })

   if type == "rg" then
      vim.cmd("Rg " .. (search_term))
   elseif type == "rgl" or type == "rgw" then
      vim.cmd('Rg -F "' .. (search_term) .. '"')
   end
end

local function cmove_with_rollover(direction)
   local quickfix_list = vim.fn.getqflist()
   local current_idx = vim.fn.getqflist({idx = 0}).idx

   if #quickfix_list == 0 then
      return
   end

   if direction == "next" then
      if current_idx >= #quickfix_list then
         vim.cmd('cfirst')
      else
         vim.cmd('cnext')
      end
   elseif direction == "prev" then
      if current_idx <= 1 then
         vim.cmd('clast')
      else
         vim.cmd('cprev')
      end
   else
      error("Invalid direction. Use 'next' or 'prev'.")
   end
end

local function cnext_rollover() cmove_with_rollover("next") end

local function cprev_rollover() cmove_with_rollover("prev") end

local cmp_enabled = true
local function toggle_autocomplete()
   if cmp_enabled then
      require("cmp").setup.buffer({ enabled = false })
      cmp_enabled = false
      print("autocomplete: disabled")
   else
      require("cmp").setup.buffer({ enabled = true })
      cmp_enabled = true
      print("autocomplete: enabled")
   end
end

local function toggle_quickfix()
    local windows = vim.fn.getwininfo()
    local quickfix_open = false

    for _, win in pairs(windows) do
        if win.quickfix == 1 then
            quickfix_open = true
            break
        end
    end

    if quickfix_open then
        vim.cmd('cclose')
    else
        vim.cmd('copen')
    end
end

local function toggle_virtual_text()
   local current_state = vim.diagnostic.config().virtual_text
   vim.g.diagnostics_visible = true
   vim.diagnostic.config({ virtual_text = not current_state })
end

local function show_hover()
   local diagnostics = vim.diagnostic.get(0, { lnum = vim.api.nvim_win_get_cursor(0)[1] - 1 })

   if #diagnostics > 0 then
      vim.diagnostic.open_float(nil, { focusable = false, scope = "line" })
   else
      vim.lsp.buf.hover()
   end
end

local function jump_into_hover_window()
   vim.lsp.buf.hover()
   vim.lsp.buf.hover()
end

local function nearest_quote()
   local line = vim.api.nvim_get_current_line()
   local cursor_col = vim.api.nvim_win_get_cursor(0)[2] + 1

   local quotes = { ['"'] = true, ["'"] = true, ['`'] = true }
   local in_quote = nil
   local start_pos = nil
   local quote_pairs = {}

   local i = 1
   while i <= #line do
      local char = line:sub(i, i)
      local prev = line:sub(i - 1, i - 1)

      if quotes[char] and prev ~= '\\' then
         if in_quote == nil then
            -- Open a quote
            in_quote = char
            start_pos = i
         elseif char == in_quote then
            -- Close current quote
            table.insert(quote_pairs, {
               quote = in_quote,
               start_pos = start_pos,
               end_pos = i,
            })
            in_quote = nil
            start_pos = nil
         end
      end

      i = i + 1
   end

   -- Find the enclosing pair nearest to the cursor
   local best_pair = nil
   local best_distance = math.huge

   for _, pair in ipairs(quote_pairs) do
      if cursor_col >= pair.start_pos and cursor_col <= pair.end_pos then
         local dist = math.min(
         math.abs(cursor_col - pair.start_pos),
         math.abs(cursor_col - pair.end_pos)
         )
         if dist < best_distance then
            best_distance = dist
            best_pair = pair
         end
      end
   end

   if best_pair then
      return best_pair.quote
   else
      vim.notify("no enclosing quote pair found", vim.log.levels.WARN)
      return nil
   end
end

local function with_nearest_quote_f(cmd, mode)
   return function()
      local start_quote = nearest_quote()
      if start_quote then
         local cmd_str
         if type(cmd) == "function" then
            cmd_str = cmd(start_quote)
         else
            cmd_str = cmd .. start_quote
         end
         vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(cmd_str, true, false, true), mode or "n", false)
      end
   end
end

local function split_args_safely(open_idx, str)
   local args = {}
   local current = {}
   local depth = { ["("] = 0, ["["] = 0, ["{"] = 0 }
   local in_string = false
   local string_char = nil
   local escape = false
   local start_idx = 0

   local function add_arg(i, extra)
      local arg = table.concat(current)
      local start_col = (open_idx + start_idx)
      table.insert(args, {
         raw = arg,
         start_col = start_col,
         end_col = (start_col + (#arg - 1) + extra)
      })
      current = {}
      start_idx = i
   end

   local function in_nesting()
      return depth["("] > 0 or depth["["] > 0 or depth["{"] > 0
   end

   for i = 1, #str do
      local char = str:sub(i, i)

      if escape then
         escape = false
         table.insert(current, char)
      elseif char == "\\" then
         escape = true
         table.insert(current, char)

      elseif in_string then
         table.insert(current, char)
         if char == string_char then
            in_string = false
            string_char = nil
         end

      elseif char == "'" or char == '"' or char == "`" then
         in_string = true
         string_char = char
         table.insert(current, char)

      elseif char == "," and not in_nesting() then
         add_arg(i, 1)

      else
         table.insert(current, char)
         if char == "(" or char == "[" or char == "{" then
            depth[char] = depth[char] + 1
         elseif char == ")" then
            depth["("] = math.max(0, depth["("] - 1)
         elseif char == "]" then
            depth["["] = math.max(0, depth["["] - 1)
         elseif char == "}" then
            depth["{"] = math.max(0, depth["{"] - 1)
         end
      end
   end

   if #current > 0 then add_arg(nil, 0) end

   return args
end

local function find_enclosing_block(open_char, close_char, line, col)
   local open_idx, close_idx = nil, nil

   --  Scan left for unpaired open char
   local stack = 0
   for i = col, 1, -1 do
      local char = line:sub(i, i)
      if char == close_char then
         stack = stack + 1
      elseif char == open_char then
         if stack == 0 then
            open_idx = i
            break
         else
            stack = stack - 1
         end
      end
   end

   if not open_idx then return nil end

   -- Scan right for unpaired close char
   stack = 0
   for i = col, #line do
      local char = line:sub(i, i)
      if char == open_char then
         stack = stack + 1
      elseif char == close_char then
         if stack == 0 then
            close_idx = i
            break
         else
            stack = stack - 1
         end
      end
   end

   return open_idx, close_idx
end

local function comma_list_action(open_char, close_char, mode)

   local row, col = unpack(vim.api.nvim_win_get_cursor(0))
   local line = vim.api.nvim_get_current_line()
   local open_idx, close_idx = find_enclosing_block(open_char, close_char, line, col + 1)

   local fallback = false
   if not open_idx or not close_idx then
      if line:find(",") then
         open_idx = 0
         close_idx = #line + 1
         fallback = true
      else
         vim.notify("could not find enclosing block or comma-separated list", vim.log.levels.WARN)
         return
      end
   end

   local args_str = line:sub(open_idx + 1, close_idx - 1)
   local args = split_args_safely(open_idx, args_str)

   local cursor_col = col + 1
   local cursor_arg_index = nil

   for i, arg in ipairs(args) do
      if cursor_col >= arg.start_col and cursor_col <= arg.end_col then
         cursor_arg_index = i
         break
      elseif cursor_col == arg.end_col + 1 and i < #args then
         cursor_arg_index = i
         break
      elseif i < #args and cursor_col > arg.end_col and cursor_col < args[i+1].start_col then
         cursor_arg_index = i + 1
         break
      elseif i == #args and cursor_col > arg.end_col and cursor_col < close_idx then
         cursor_arg_index = i
         break
      end
   end

   if not cursor_arg_index then
      vim.notify("cursor not inside any argument", vim.log.levels.WARN)
      return
   end

   local removed = args[cursor_arg_index].raw

   local function update_registers()
      vim.fn.setreg('"', removed)
      vim.fn.setreg('+', removed)
      vim.fn.setreg('*', removed)
   end

   if mode == "change" then
      update_registers()
      args[cursor_arg_index].raw = ""
   elseif mode == "delete" then
      update_registers()
      table.remove(args, cursor_arg_index)
   elseif mode == "left" and cursor_arg_index > 1 then
      args[cursor_arg_index], args[cursor_arg_index - 1] =
         args[cursor_arg_index - 1], args[cursor_arg_index]
      cursor_arg_index = cursor_arg_index - 1
   elseif mode == "right" and cursor_arg_index < #args then
      args[cursor_arg_index], args[cursor_arg_index + 1] =
         args[cursor_arg_index + 1], args[cursor_arg_index]
      cursor_arg_index = cursor_arg_index + 1
   end

   local function set_new_args()
      local raw_args_str = line:sub(open_idx + 1, close_idx - 1)
      local leading_ws = raw_args_str:match("^(%s*)") or ""
      local trailing_ws = raw_args_str:match("(%s*)$") or ""

      local use_compact = not raw_args_str:find(",%s")
      local separator = use_compact and "," or ", "

      local trimmed_args = vim.tbl_map(function(arg) return vim.trim(arg.raw) end, args)

      -- Detect if original string had a trailing comma before trailing whitespace
      local has_trailing_comma = raw_args_str:find(",%s*$")

      local new_args = table.concat(trimmed_args, separator)
      if has_trailing_comma and #trimmed_args > 0 then
         new_args = new_args .. separator:sub(1,1) -- just the "," part
      end

      local final = leading_ws .. new_args .. trailing_ws
      local new_line = fallback
          and final
          or (line:sub(1, open_idx) .. final .. line:sub(close_idx))

      vim.api.nvim_set_current_line(new_line)

      return { lead = #leading_ws, trail = #trailing_ws, delim = #separator }
   end

   local function set_new_cursor_col(spacing)
      local change_col = open_idx + 1 + spacing.lead
      for i = 1, cursor_arg_index - 1 do
         change_col = change_col + #vim.trim(args[i].raw)
         if i ~= #args then change_col = change_col + spacing.delim end
      end
      vim.fn.cursor(row, change_col)
   end

   local spacing = set_new_args()
   set_new_cursor_col(spacing)

   if mode == "change" then vim.cmd("startinsert") end

end

_G.comma_list_action = comma_list_action

local function setup_comma_list_actions(key, open, close)

   local actions = { c = "change", d = "delete", h = "left", l = "right" }

   for act_key, action in pairs(actions) do

      local plug = '<Plug>CommaListAction' .. act_key .. key

      vim.keymap.set('n', plug, function()
         comma_list_action(open, close, action)
         vim.fn['repeat#set'](vim.api.nvim_replace_termcodes(plug, true, false, true), vim.v.count)
      end)

      if act_key == "d" or act_key == "c" then
         vim.keymap.set('n', act_key .. "," .. key, plug)
      else
         vim.keymap.set('n', "," .. key .. act_key, plug)
      end

   end

end

-- d,b c,b ,bh ,bl for b, p, a
setup_comma_list_actions("p", "(", ")")
setup_comma_list_actions("k", "[", "]")
setup_comma_list_actions("b", "{", "}")



vim.keymap.set({ "n", "i" }, '<C-q>', '<cmd>wqall<cr>', { desc = "write quit all with <c-q>" })

-- one less key for command mode
vim.keymap.set({ "n", "v" }, ":", ";")
vim.keymap.set({ "n", "v" }, ";", ":")

-- vim.keymap.set("n", "<leader>cf", function() vim.api.nvim_feedkeys("ysiw)i", "n", false) end)
-- vim.keymap.set("v", "<leader>cf", function() vim.api.nvim_feedkeys("S)i", "x", false) end)

vim.keymap.set("n", "ycf", "<Plug>Ysurroundiw)i")
-- vim.keymap.set("v", "cf", "<Plug>VSurround)i")

vim.keymap.set("n", "H", "^")

vim.keymap.set({ "n", "i" }, '<up>', '<nop>', { desc = "prevent bad habits, disable up arrow" })
vim.keymap.set({ "n", "i" }, '<down>', '<nop>', { desc = "prevent bad habits, disable down arrow" })
vim.keymap.set({ "n", "i" }, '<left>', '<nop>', { desc = "prevent bad habits, disable left arrow" })
vim.keymap.set({ "n", "i" }, '<right>', '<nop>', { desc = "prevent bad habits, disable right arrow" })

-- Resize windows with arrow keys
vim.keymap.set('n', '<down>', ':vertical resize -3<CR>', { silent = true, desc = "move split left" })
vim.keymap.set('n', '<up>',   ':vertical resize +3<CR>', { silent = true, desc = "move split right" })

vim.keymap.set('n', '*', "<Plug>(asterisk-z*)<Plug>(is-nohl-1)", { desc = "fancy *" })
vim.keymap.set('n', 'g*', "<Plug>(asterisk-gz*)<Plug>(is-nohl-1)", { desc = "fancy g*" })
vim.keymap.set('n', '#', "<Plug>(asterisk-z#)<Plug>(is-nohl-1)", { desc = "fancy #" })
vim.keymap.set('n', 'g#', "<Plug>(asterisk-gz#)<Plug>(is-nohl-1)", { desc = "fancy g#" })

-- vim.keymap.set({ "n", "o", "x" }, ",w", "<cmd>lua require('spider').motion('w')<CR>", { desc = "Spider-w" })
-- vim.keymap.set({ "n", "o", "x" }, ",e", "<cmd>lua require('spider').motion('e')<CR>", { desc = "Spider-e" })
-- vim.keymap.set({ "n", "o", "x" }, ",b", "<cmd>lua require('spider').motion('b')<CR>", { desc = "Spider-b" })


vim.keymap.set('n', 'dib', "di{", { desc = "delete inside braces {}" })
vim.keymap.set('n', 'dip', "di(", { desc = "delete inside parens ()" })
vim.keymap.set('n', 'dik', "di[", { desc = "delete inside brakets []" })
vim.keymap.set('n', 'diq', with_nearest_quote_f("di"), { desc = "delete inside quotes" })

vim.keymap.set('n', 'dab', "da{", { desc = "delete a braces {}" })
vim.keymap.set('n', 'dap', "da(", { desc = "delete a parens ()" })
vim.keymap.set('n', 'dak', "da[", { desc = "delete a brakets []" })
vim.keymap.set('n', 'daq', with_nearest_quote_f("da"), { desc = "delete a quote" })

vim.keymap.set('n', 'dsb', "<Plug>Dsurround{", { desc = "delete surrounding braces {}", remap = true })
vim.keymap.set('n', 'dsp', "<Plug>Dsurround(", { desc = "delete surrounding parens ()", remap = true })
vim.keymap.set('n', 'dsk', "<Plug>Dsurround[", { desc = "delete surrounding brakets []", remap = true })
vim.keymap.set('n', 'ds<space>', "F<space>xf<space>x", { desc = "delete surrounding spaces" })

-- vim.keymap.set('n', 'yib', "yi{", { desc = "yank inside braces {}" })
-- vim.keymap.set('n', 'yip', "yi(", { desc = "yank inside parens ()" })
-- vim.keymap.set('n', 'yik', "yi[", { desc = "yank inside brakets []" })
-- vim.keymap.set('n', 'yiq', with_nearest_quote_f("yi"), { desc = "yank inside nearest matching quote [\"'`]" })

-- vim.keymap.set('n', 'yab', "ya{", { desc = "yank a braces {}" })
-- vim.keymap.set('n', 'yap', "ya(", { desc = "yank a parens ()" })
-- vim.keymap.set('n', 'yak', "ya[", { desc = "yank a brakets []" })
-- vim.keymap.set('n', 'yaq', with_nearest_quote_f("ya"), { desc = "yank a nearest matching quote [\"'`]" })

vim.keymap.set('n', 'cib', "ci{", { desc = "change inside braces" })
vim.keymap.set('n', 'cip', "ci(", { desc = "change inside parens" })
vim.keymap.set('n', 'cik', "ci[", { desc = "change inside brakets" })
vim.keymap.set('n', 'ciq', with_nearest_quote_f("ci"), { desc = "change inside quotes" })

vim.keymap.set('n', 'cab', "ca{", { desc = "change a braces" })
vim.keymap.set('n', 'cap', "ca(", { desc = "change a parens" })
vim.keymap.set('n', 'cak', "ca[", { desc = "change a brakets []" })
vim.keymap.set('n', 'caq', with_nearest_quote_f("ca"), { desc = "change a quotes" })

-- vim.keymap.set('n', ',cab', "ca{", { desc = "change a braces {}" })
-- vim.keymap.set('n', ',cap', "ca(", { desc = "change a parens ()" })
-- vim.keymap.set('n', ',cak', "ca[", { desc = "change a brackets []" })
-- vim.keymap.set('n', ',caq', with_nearest_quote_f("ca"), { desc = "change a quotes" })

vim.keymap.set('n', ',cb', "cs{", { desc = "change surrounding braces", remap = true })
vim.keymap.set('n', ',cbk', ",cb]", { desc = "change surrounding braces to brakets", remap = true })
vim.keymap.set('n', ',cbp', ",cb)", { desc = "change surrounding braces to parens", remap = true })
vim.keymap.set('n', ',cp', "cs(", { desc = "change surrounding parens", remap = true })
vim.keymap.set('n', ',cpk', ",cp]", { desc = "change surrounding parens to brakets", remap = true })
vim.keymap.set('n', ',cpb', ",cp}", { desc = "change surrounding parens to braces", remap = true })
vim.keymap.set('n', ',ca', "cs[", { desc = "change surrounding brakets", remap = true })
vim.keymap.set('n', ',ckp', ",ca)", { desc = "change surrounding brakets to parens", remap = true })
vim.keymap.set('n', ',ckb', ",ca}", { desc = "change surrounding brakets to braces", remap = true })
vim.keymap.set('n', ',cq', with_nearest_quote_f("cs", "m"), { desc = "change surrounding quotes", remap = true })
-- vim.keymap.set('n', ',cqk', with_nearest_quote_f(",cq["), { desc = "change surrounding quotes to brakets", remap = true })
-- vim.keymap.set('n', ',cqb', with_nearest_quote_f(",cq{"), { desc = "change surrounding quotes to braces", remap = true })
-- vim.keymap.set('n', ',cqp', with_nearest_quote_f(",cq("), { desc = "change surrounding quotes to parens", remap = true })

-- vim.keymap.set({ 'n' }, ',sb', "<Plug>Ysurroundiw}", { desc = "surround with braces {}", remap = true })
-- vim.keymap.set({ 'n' }, ',sk', "<Plug>Ysurroundiw]", { desc = "surround with brakets []", remap = true })
-- vim.keymap.set({ 'n' }, ',sp', "<Plug>Ysurroundiw)", { desc = "surround with parens ()", remap = true })
-- vim.keymap.set({ 'v' }, ',sb', "<Plug>Ysurround}", { desc = "surround with braces {}", remap = true })
-- vim.keymap.set({ 'v' }, ',sk', "<Plug>Ysurround]", { desc = "surround with brakets []", remap = true })
-- vim.keymap.set({ 'v' }, ',sp', "<Plug>Ysurround)", { desc = "surround with parens ()", remap = true })
-- vim.keymap.set({ 'v' }, ',s`', "<Plug>Ysurround`", { desc = "surround with braces {}", remap = true })
-- vim.keymap.set({ 'v' }, ',s"', "<Plug>Ysurround\"", { desc = "surround with brakets []", remap = true })
-- vim.keymap.set({ 'v' }, ',s\'', "<Plug>Ysurround'", { desc = "surround with parens ()", remap = true })

vim.keymap.set("n", "<space>l", "a <esc>")
vim.keymap.set("n", "<space>h", "i <esc>")
vim.keymap.set("n", "<leader>u", ":MundoToggle<cr>")

vim.keymap.set("x", ",lo", [[:s/\([.!?]\)\s\+/\1\r/g | s/(/\\r(/g<CR>]], { desc = "turn a long line into a bunch of sentences on new lines." })
vim.keymap.set("x", ".", ":'<,'>normal .<CR>", { desc = "run . on all lines in a selection" })

vim.keymap.set("n", ",sc", function()
  local line = vim.api.nvim_get_current_line()
  local indent = line:match("^%s*") or ""
  local content = line:match("^%s*(.-)%s*$") or ""
  content = content:gsub("`", "\\`")
  vim.api.nvim_set_current_line(indent .. 'code.push(`' .. content .. '`)')
end, { desc = "wrap current line with code.push(`...`)" })

vim.keymap.set('n', ', b', "cs}{", { desc = "add space inside braces", remap = true })
vim.keymap.set('n', ', p', "cs)(", { desc = "add space inside parens" , remap = true })
vim.keymap.set('n', ', k', "cs][", { desc = "add space inside brakets []" , remap = true })
vim.keymap.set('n', ', q', with_nearest_quote_f(function(quote) return("cs" .. quote .. " " .. quote) end, "m"), { desc = "add space inside quotes" , remap = true })

vim.keymap.set('n', 'deb', "ct} <esc>", { desc = "delete till }" })
vim.keymap.set('n', 'dep', "ci) <esc>", { desc = "delete till )" })
vim.keymap.set('n', 'dek', "ci] <esc>", { desc = "delete till ]" })
vim.keymap.set('n', 'ceb', "ct} <left>", { desc = "delete inside braces {}" })
vim.keymap.set('n', 'cep', "ci) <left>", { desc = "delete inside parens ()" })
vim.keymap.set('n', 'cek', "ci] <left>", { desc = "delete inside brakets []" })

vim.keymap.set("n", "ph", "p", { desc = "paste here" })
vim.keymap.set("n", "pf", "p=`]", { desc = "paste after and indent" })
vim.keymap.set("n", ",fb", "vi{=", { desc = "indent block" })

local function make_slash_textobj(include_start_delim, include_trail_delim)
   return function()
      local save_cursor = vim.api.nvim_win_get_cursor(0)

      -- Search backward for opening slash
      if vim.fn.search("/", "bW") == 0 then return end
      local start_pos = vim.api.nvim_win_get_cursor(0)

      -- Search forward for closing slash
      if vim.fn.search("/", "W") == 0 then
         vim.api.nvim_win_set_cursor(0, save_cursor)
         return
      end
      local end_pos = vim.api.nvim_win_get_cursor(0)

      if include_start_delim then
         vim.api.nvim_win_set_cursor(0, start_pos)
      else
         vim.api.nvim_win_set_cursor(0, {start_pos[1], start_pos[2] + 1})
      end

      vim.cmd("normal! v")

      if include_trail_delim then
         vim.api.nvim_win_set_cursor(0, end_pos)
      else
         vim.api.nvim_win_set_cursor(0, {end_pos[1], end_pos[2] - 1})
      end
   end
end

vim.keymap.set({ "o", "x" }, "i/", make_slash_textobj(false, false), { desc = "inside /.../" })
vim.keymap.set({ "o", "x" }, "a/", make_slash_textobj(false, true), { desc = "a .../" })

-- this whole thing is a . repeat plugin example
-- local function add_space_inside_quote()
   -- vim.fn['repeat#set'](vim.api.nvim_replace_termcodes('<Plug>AddSpaceInsideQuotes', true, false, true), vim.v.count)
-- end
-- _G.add_space_inside_quote = add_space_inside_quote
-- this is so we can . repeat it. you need the plug for repeat#set
-- vim.keymap.set('n', '<Plug>AddSpaceInsideQuotes', ":lua add_space_inside_quote()<cr>")
-- vim.keymap.set("n", "siq", add_space_inside_quote, { desc = "add space inside closest quotes" })

-- change how macros work
-- vim.keymap.set('n', 'q', "<nop>", { desc = "recoup q, we're changing how macros work" })

-- easy macro
-- vim.keymap.set("n", ",,", "@@")

-- vim.keymap.set('n', 'qq', "<plug>(Mac_RecordNew)")
-- vim.keymap.set('n', 'qh', "<cmd>DisplayMacroHistory<cr>")

-- vim.keymap.set('n', ',,', "<plug>(Mac_Play)")
-- vim.keymap.set('n', 'qq', "<plug>(Mac_RecordNew)")

vim.keymap.set('n', ',,', "@q")
-- vim.keymap.set('n', 'qq', "<plug>(Mac_RecordNew)")


-- turns out I use "r" a fuck ton.
-- vim.keymap.set('n', 'r', "<nop>", { desc = "recoup r characters we don't use much" })
-- vim.keymap.set('n', 'rr', "r", { desc = "move r to rr" })
-- vim.keymap.set('n', 'rx', "rx", { desc = "rx is a thing you use a lot" })

-- turns out I use "x" a fuck ton.
-- vim.keymap.set('n', 'x', "<nop>", { desc = "recoup x" })
-- vim.keymap.set('n', 'xx', "x", { desc = "move x to xx" })

-- add some yanks to y
vim.keymap.set('n', 'yl', 'y$', { desc = "yank to end of line" })
vim.keymap.set('n', 'Y', 'y$', { desc = "yank to end of line" })
vim.keymap.set('n', 'yh', 'y^', { desc = "yank to beginning of line" })

-- i key, think "insert <somewhere>"

-- these were cute but all of them moved to hop commands
vim.keymap.set('n', 'i', "<nop>", { desc = "recoup i" })
vim.keymap.set('n', 'p', "<nop>", { desc = "recoup p" })
vim.keymap.set('n', 'pp', "p", { desc = "p" })

-- this is me trying to break a bad habit.
-- i should be moving and inserting at the same time
vim.keymap.set('n', 'aaaa', "a", { desc = "move a to aaaa" })
vim.keymap.set('n', 'iiii', "i", { desc = "move i to iiii" })

--- e -- thing execute
vim.keymap.set('n', 'eeee', "e", { desc = "move e to eeee" })

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
-- vim.keymap.set('n', 'i)', "f)a", { desc = "insert at first )" } ]
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


vim.keymap.set('n', '<leader>id', function()
  local ts = os.date("%Y-%m-%d %H:%M")
  vim.api.nvim_put({ ts }, "c", true, true)
end, { desc = "insert date" })

vim.keymap.set('n', '<leader>im', function()
  local ts = '= ' .. os.date("%Y-%m-%d %H:%M") .. ''
  vim.api.nvim_put({ ts }, "c", true, true)
end, { desc = "insert date marker with =" })


-- rework how marks / links work
vim.keymap.set('n', '`', "<nop>", { desc = "disable '" })
vim.keymap.set('n', "'", "<nop>", { desc = "disable `" })
vim.keymap.set('n', 'L', "m", { desc = "make a link (mark) '" })
vim.keymap.set('n', 'gl', "`", { desc = "jump to link (mark) '" })


-- i always want linewise to start, but can switch to charwise with one more "v".
-- this is maybe my favorite remap ever.
vim.keymap.set('n', 'v', "V", { desc = "start v linewise" })
vim.keymap.set('n', 'vv', "v", { desc = "change v to charwise with extra v" })


-- this only works because i have <c-/> mapped to $ in carabiner
vim.keymap.set('n', '$', fuzzy_search, { desc = "fuzzy search with <c-/> (if you have <c-/> mapped to $)" })

local function commandt_f(cmd)
   -- if highlight is on it makes the searched word
   -- invisible in the cursor line of the command t window
   return function()
      vim.cmd('nohlsearch')
      vim.cmd(cmd)
   end
end

-- CommandT excludes no files, CommandTFind excludes some files. see the code in command-t.lua
vim.keymap.set('n', '<leader>o', commandt_f('CommandTFind'))
-- vim.keymap.set('n', '<leader>o', ':CommandTFind<cr>')
-- vim.keymap.set('n', '<leader>ll', ':CommandT<cr>')
-- vim.keymap.set('n', '<leader>lb', ':CommandTBuffer<cr>')
-- vim.keymap.set('n', '<leader>a', toggle_autocomplete)

vim.keymap.set("n", "-", "<CMD>Oil --float<CR>", { desc = "open buffer directory using oil" })

-- google shit. open links

vim.keymap.set('n', '<Leader>gl', function()
  vim.cmd('call OpenURI()')
end, { silent = true, desc = "open link in browser" })

vim.keymap.set('n', '<leader>gg', function()
   vim.cmd('normal! "gyiw')
   vim.cmd('call GoogleSearch()')
end, { silent = true, desc = "google word under cursor" })

vim.keymap.set('n', '<leader>gi\'', function()
   vim.cmd('normal! "gyi\'')
   vim.cmd('call GoogleSearch()')
end, { silent = true, desc = "google word inside '" })

vim.keymap.set('n', '<leader>gi"', function()
   vim.cmd('normal! "gyi"')
   vim.cmd('call GoogleSearch()')
end, { silent = true, desc = "google words inside \"" })

vim.keymap.set('v', '<leader>gg', function()
   vim.cmd('normal! "gy')
   vim.cmd('call GoogleSearch()')
end, { silent = true, desc = "google visual selection" })

vim.keymap.set('n', '<leader>/', ":noh<cr>", { desc = "turn off search highlighting" })

vim.keymap.set("n", "<leader>ft", function()
   local from = vim.fn.input("from: ")
   local to = vim.fn.input("to: ")
   vim.fn["ChangeSoftTabs"](from, to)
end, { desc = "fix tabs from one width to another" })

vim.keymap.set("n", "<leader>fq", function()
   vim.fn["FixQuotes"]()
end, { desc = "turn unicode quotes into ansi quotes" })

vim.keymap.set("n", "<leader>z", function()
   vim.fn["ToggleWrap"]()
end, { desc = "toggle text wrap and fix how motions work" })


-- s key -- think "search" and "show" and "surround"

vim.keymap.set('n', 's', "<nop>", { desc = "recoup s" })
vim.keymap.set('n', 'ss', "s", { desc = "enable s as ss" })


-- vim.keymap.set('n', 's;', ":w<CR>", { desc = "save with s;" })

-- vim.keymap.set('n', '[f', cprev_rollover)
-- vim.keymap.set('n', ']f', cnext_rollover)
vim.keymap.set('n', 'sq', toggle_quickfix, { desc = "toggle quickfix" })
vim.keymap.set('n', 'sp', cprev_rollover, { desc = "skip to previous quickfix" })
vim.keymap.set('n', 'sn', cnext_rollover, { desc = "skip to next quickfix" })

vim.keymap.set('n', 'sff', bind(rg_and_open_first, "rg"), { desc = "search files with pattern, rg, open in new tab, jump to first result" })
vim.keymap.set('n', 'sfl', bind(rg_and_open_first, "rgl"), { desc = "search files with literal, rgl, open in new tab, jump to first result" })
vim.keymap.set('n', 'sfw', bind(rg_and_open_first, "rgw"), { desc = "search files for word under cursor, rgl for word under cursor, open new tab, jump to first result" })
vim.keymap.set('n', 'sr', ':%s///g<left><left>', { desc = "replace whatever you last searched for (buffer wide)" })
vim.keymap.set('n', 'sd', ':/_\\.<cr>', { desc = "search for _." })

-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set('n', 'sl', toggle_virtual_text)
-- vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
-- vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
-- vim.keymap.set('n', 'sdd', vim.diagnostic.setloclist)

vim.keymap.set('n', 'sh', show_hover, { desc = "show hover window" })

vim.keymap.set('n', 'so', ':w | source %<CR>', { desc = "save and source current file" })

vim.keymap.set("n", ",bo", function()
   local cur_row = vim.api.nvim_win_get_cursor(0)[1]
   local line = vim.api.nvim_get_current_line()

   local before, body, after = line:match("^(.-){(.-)}(.*)$")
   if not body then return end

   -- Split statements
   local statements = {}
   for stmt in body:gmatch("([^;]+)") do
      local trimmed = vim.trim(stmt)
      if trimmed ~= "" then
         table.insert(statements, trimmed .. ";")
      end
   end
   if #statements == 0 then return end

   -- Replace current line with multiline block (unindented for now)
   local new_lines = { before .. "{" }
   for _, stmt in ipairs(statements) do
      table.insert(new_lines, stmt)
   end
   table.insert(new_lines, "}" .. after)

   vim.api.nvim_buf_set_lines(0, cur_row - 1, cur_row, false, new_lines)

   -- Reselect the block and auto-indent it
   -- vim.api.nvim_win_set_cursor(0, { cur_row, 0 })
   vim.cmd("normal! va{=j")

end, { desc = "open single-line { } block into multi-line" })

vim.keymap.set("n", ",bc", "va{J", { desc = "close multi-line { } block to one line" })


vim.api.nvim_create_autocmd('LspAttach', {
   group = vim.api.nvim_create_augroup('UserLspConfig', {}),
   callback = function(ev)
      -- Enable completion triggered by <c-x><c-o>
      vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

      -- Buffer local mappings.
      -- See `:help vim.lsp.*` for documentation on any of the below functions

      local opts = { buffer = ev.buf }

      vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts, { desc = "jump to definition of thing under cursor" })
      -- vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
      vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts, { desc = "jump to implementation of thing under cursor" })
      vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts, { desc = "show list of references to thing under cursor" })
      -- vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)

      -- vim.keymap.set('n', 'sh', jump_into_hover_window, opts)
      vim.keymap.set('n', 'crn', vim.lsp.buf.rename, opts, { desc = "rename the thing under the cursor" })
      vim.keymap.set({ 'n' }, 'ea', vim.lsp.buf.code_action, opts, { desc = "do a code action" })

      -- can't use w slows down easymotions
      -- vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, opts)
      -- vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, opts)
      -- vim.keymap.set('n', '<leader>wl', function()
      -- print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
      -- end, opts)
      -- vim.keymap.set('n', 'gD', vim.lsp.buf.type_definition, opts)
      -- can't use "r" as first letter. slows swap
      -- can't use "c" as first letter. slows comment
      -- vim.keymap.set('n', '<leader>f', function()
      --   vim.lsp.buf.format { async = true }
      -- end, opts)
   end,
})

