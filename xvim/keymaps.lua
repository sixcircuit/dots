
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

vim.keymap.set({ "n", "i" }, '<C-q>', '<cmd>wqall<cr>', { desc = "write quit all with <c-q>" })

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

vim.keymap.set({ "n", "o", "x" }, ",w", "<cmd>lua require('spider').motion('w')<CR>", { desc = "Spider-w" })
vim.keymap.set({ "n", "o", "x" }, ",e", "<cmd>lua require('spider').motion('e')<CR>", { desc = "Spider-e" })
vim.keymap.set({ "n", "o", "x" }, ",b", "<cmd>lua require('spider').motion('b')<CR>", { desc = "Spider-b" })


vim.keymap.set('n', 'dib', "di{", { desc = "delete inside braces {}" })
vim.keymap.set('n', 'dip', "di(", { desc = "delete inside parens ()" })
vim.keymap.set('n', 'dia', "di[", { desc = "delete inside array []" })
vim.keymap.set('n', 'cib', "ci{", { desc = "change inside braces" })
vim.keymap.set('n', 'cip', "ci(", { desc = "change inside parens" })
vim.keymap.set('n', 'cia', "ci[", { desc = "change inside array []" })
vim.keymap.set('n', 'csb', "cs{", { desc = "change surrounding braces" })
vim.keymap.set('n', 'csp', "cs(", { desc = "change surrounding parens" })
vim.keymap.set('n', 'csa', "cs[", { desc = "change surrounding array []" })
vim.keymap.set('n', 'sib', "cs}{", { desc = "add space inside braces", remap = true })
vim.keymap.set('n', 'sip', "cs)(", { desc = "add space inside parens" , remap = true })
vim.keymap.set('n', 'sia', "cs][", { desc = "add space inside array []" , remap = true })
vim.keymap.set('n', 'dsb', "<Plug>Dsurround{", { desc = "delete surrounding braces {}" })
vim.keymap.set('n', 'dsp', "<Plug>Dsurround(", { desc = "delete surrounding parens ()" })
vim.keymap.set('n', 'dsa', "<Plug>Dsurround[", { desc = "delete surrounding array []" })
vim.keymap.set('n', 'ds<space>', "F<space>xf<space>x", { desc = "delete surrounding spaces" })

local function add_space_inside_quote()
   local row, col = unpack(vim.api.nvim_win_get_cursor(0))
   local line = vim.api.nvim_get_current_line()

   local quote_chars = { '"', "'", "`" }

   local start_pos, end_pos, quote

   -- Search for nearest quote pair around cursor
   for _, q in ipairs(quote_chars) do
      local s, e = line:find(q .. ".-" .. q)
      if s and e and (not start_pos or math.abs(col + 1 - ((s + e) / 2)) < math.abs(col + 1 - ((start_pos + end_pos) / 2))) then
         start_pos, end_pos, quote = s, e, q
      end
   end

   if start_pos and end_pos and end_pos - start_pos > 1 then
      local inner = line:sub(start_pos + 1, end_pos - 1)
      local new_line = line:sub(1, start_pos) .. " " .. inner .. " " .. line:sub(end_pos)
      vim.api.nvim_set_current_line(new_line)
   else
      print("no matching quotes found.")
   end

   vim.fn['repeat#set'](vim.api.nvim_replace_termcodes('<Plug>AddSpaceInsideQuotes', true, false, true), vim.v.count)
end

_G.add_space_inside_quote = add_space_inside_quote

vim.keymap.set('n', '<Plug>AddSpaceInsideQuotes', ":lua add_space_inside_quote()<cr>")
vim.keymap.set("n", "siq", add_space_inside_quote, { desc = "add space inside closest quotes" })

-- change how macros work
vim.keymap.set('n', 'q', "<nop>", { desc = "recoup q, we're changing how macros work" })

-- easy macro
-- vim.keymap.set("n", ",,", "@@")

-- vim.keymap.set('n', 'qq', "<plug>(Mac_RecordNew)")
-- vim.keymap.set('n', 'qh', "<cmd>DisplayMacroHistory<cr>")

vim.keymap.set('n', ',,', "<plug>(Mac_Play)")
vim.keymap.set('n', 'qq', "<plug>(Mac_RecordNew)")

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

-- i key, think "insert stuff"

vim.keymap.set('n', 'i', "<nop>", { desc = "recoup i" })
vim.keymap.set('n', 'ii', "i", { desc = "move i to ii" })

vim.keymap.set('n', 'id', function()
  local ts = os.date("%Y-%m-%d %H:%M")
  vim.api.nvim_put({ ts }, "c", true, true)
end, { desc = "insert date" })

vim.keymap.set('n', 'im', function()
  local ts = '= ' .. os.date("%Y-%m-%d %H:%M") .. ''
  vim.api.nvim_put({ ts }, "c", true, true)
end, { desc = "insert date marker with =" })


-- rework how marks / links work
vim.keymap.set('n', '`', "<nop>", { desc = "disable '" })
vim.keymap.set('n', "'", "<nop>", { desc = "disable `" })
vim.keymap.set('n', 'gl', "`", { desc = "make a link (mark) '" })
vim.keymap.set('n', 'L', "m", { desc = "jump to link (mark) '" })


-- i always want linewise to start, but can switch to charwise with one more "v".
-- this is maybe my favorite remap ever.
vim.keymap.set('n', 'v', "V", { desc = "start v linewise" })
vim.keymap.set('n', 'vv', "v", { desc = "change v to charwise with extra v" })


-- this only works because i have <c-/> mapped to $ in carabiner
vim.keymap.set('n', '$', fuzzy_search, { desc = "fuzzy search with <c-/> (if you have <c-/> mapped to $)" })


-- CommandT excludes no files, CommandTFind excludes some files. see the code in command-t.lua
vim.keymap.set('n', '<leader>o', ':CommandTFind<cr>')
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

-- s key -- think "search" and "show"

vim.keymap.set('n', 's', "<nop>", { desc = "recoup s" })
vim.keymap.set('n', 'ss', "s", { desc = "enable s as ss" })

vim.keymap.set('n', 'swb', "<Plug>Ysurroundiw}", { remap = true, desc = "surround with {" })
vim.keymap.set('n', 'swa', "<Plug>Ysurroundiw]", { remap = true, desc = "surround with [" })
vim.keymap.set('n', 'swp', "<Plug>Ysurroundiw)", { remap = true, desc = "surround with (" })

vim.keymap.set('n', 'csb', "<Plug>Csurround}", { remap = true, desc = "surround with {" })
vim.keymap.set('n', 'csa', "<Plug>Csurround]", { remap = true, desc = "surround with [" })
vim.keymap.set('n', 'csp', "<Plug>Csurround)", { remap = true, desc = "surround with (" })

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
      vim.keymap.set({ 'n' }, 'caa', vim.lsp.buf.code_action, opts, { desc = "do a code action" })

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

