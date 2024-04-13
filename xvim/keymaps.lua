

function insert_cmd_output(cmd)
   local temp_file = "/tmp/temp_cmd_output.txt"
   vim.cmd("silent ! " .. cmd .. " > " .. temp_file)
   local file = io.open(temp_file, "r")
   local data = {}
   for line in file:lines() do
      table.insert(data, line)
   end
   vim.api.nvim_put(data, 'l', false, true)
   file:close()
   os.remove(temp_file)
end


function insert_text(command)

   function insert_text_at_cursor(text)
      vim.schedule(function()
         local row, col = unpack(vim.api.nvim_win_get_cursor(0))
         local text_without_newlines = string.gsub(text, "\n", "\\n")
         vim.api.nvim_buf_set_lines(0, row - 1, row - 1, false, {text_without_newlines})
      end)
   end

   local uv = require('luv')
   local stdin = uv.new_pipe()
   local stdout = uv.new_pipe()
   local stderr = uv.new_pipe()
   print("stdin", stdin)
   print("stdout", stdout)
   print("stderr", stderr)
   local handle, pid = uv.spawn("/bin/bash", {
      -- args = { "-c", "echo hello; sleep 1; echo blah; sleep 5; echo world" },
      args = { "-c", "stream.lingo" },
      stdio = {stdin, stdout, stderr}
   }, function(code, signal) -- on exit
     print("exit code", code)
     print("exit signal", signal)
   end)
   print("process opened", handle, pid)
   uv.read_start(stdout, function(err, data)
     assert(not err, err)
     if data then
       print("stdout chunk", stdout, data)
       insert_text_at_cursor(data)
     else
       print("stdout end", stdout)
     end
   end)
   uv.read_start(stderr, function(err, data)
     assert(not err, err)
     if data then
       print("stderr chunk", stderr, data)
     else
       print("stderr end", stderr)
     end
   end)
   -- uv.write(stdin, "Hello World")
end

-- function term_to_scratch(command)
-- end

-- vim.api.nvim_command([[command! -nargs=1 TermToScratch lua term_to_scratch(<f-args>)]])

local function rg_and_open_first()
   local status, search_term = pcall(vim.fn.input, 'rg/')
   if not status then
      return
   end
   vim.cmd('Rg ' .. search_term)
   vim.cmd('cc 1')
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

vim.keymap.set('n', '[f', cprev_rollover)
vim.keymap.set('n', ']f', cnext_rollover)

-- i always want linewise to start, but can switch to charwise with one more "v".
-- this is maybe my favorite remap ever.
vim.keymap.set('n', 'v', "V")
vim.keymap.set('n', 'vv', "v")

vim.keymap.set('n', 's', "<nop>")
vim.keymap.set('n', 'ss', "s")
vim.keymap.set('n', 's;', ":w<CR>")
vim.keymap.set('n', 'sq', toggle_quickfix)
vim.keymap.set('n', 'sp', cprev_rollover)
vim.keymap.set('n', 'sn', cnext_rollover)

-- vim.api.nvim_set_keymap('n', '<CR>', ':w<CR>', { noremap = true, silent = false })

-- vim.api.nvim_set_keymap('n', '<leader>o', ':CommandTRipgrep<cr>', { noremap = true, silent = true })

-- easy macro
vim.keymap.set('', ',,', "@@")

vim.keymap.set({ "n", "i" }, '<C-q>', '<cmd>wqall<cr>')

-- CommandT excludes no files, CommandTFind excludes some files. see the code in command-t.lua
vim.keymap.set('n', '<leader>o', ':CommandTFind<cr>')
-- vim.keymap.set('n', '<leader>lo', ':CommandT<cr>')
-- vim.keymap.set('n', '<leader>ll', ':CommandT<cr>')
-- vim.keymap.set('n', '<leader>lb', ':CommandTBuffer<cr>')
-- vim.keymap.set('n', '<leader>a', toggle_autocomplete)
-- vim.keymap.set('n', '<leader>o', ':CommandTBuffer<cr>')

local function fuzzy_search()
   vim.g.fuzzysearch_prompt = 'fz/'
   -- local status, err = pcall(vim.fn['fuzzysearch#start_search'])
   local status, _ = pcall(vim.fn['fuzzysearch#start_search'])
   if not status then
      vim.print("")
   end
end

vim.keymap.set("n", "-", "<CMD>Oil --float<CR>", { desc = "Open parent directory" })

vim.keymap.set('', '/', "<nop>")

vim.keymap.set('n', '<Leader>gl', function()
  vim.cmd('call OpenURI()')
end, { silent = true })

vim.keymap.set('n', '<leader>gg', function()
   vim.cmd('normal! "gyiw')
   vim.cmd('call GoogleSearch()')
end, { silent = true })

vim.keymap.set('n', '<leader>gi\'', function()
   vim.cmd('normal! "gyi\'')
   vim.cmd('call GoogleSearch()')
end, { silent = true })

vim.keymap.set('n', '<leader>gi"', function()
   vim.cmd('normal! "gyi"')
   vim.cmd('call GoogleSearch()')
end, { silent = true })

vim.keymap.set('v', '<leader>gg', function()
   vim.cmd('normal! "gy')
   vim.cmd('call GoogleSearch()')
end, { silent = true })

-- this only works because i have <c-/> mapped to $ in carabiner
vim.keymap.set({ 'n', 'v' }, '$', "/") -- <c-/>
vim.keymap.set('', '/', fuzzy_search)
vim.keymap.set('n', 'sf', rg_and_open_first)
vim.keymap.set('', 'sr', ':%s///g<left><left>')

-- " clear search highlighting
vim.keymap.set('', '<leader>/', ":noh<cr>")

local function toggle_virtual_text()
   local current_state = vim.diagnostic.config().virtual_text
   vim.g.diagnostics_visible = true
   vim.diagnostic.config({ virtual_text = not current_state })
end

local function toggle_diagnostics()
   if vim.g.diagnostics_visible == nil or vim.g.diagnostics_visible == false then
      vim.diagnostic.show()
      vim.g.diagnostics_visible = true
   else
      vim.diagnostic.hide()
      vim.g.diagnostics_visible = false
   end
end

-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set('n', 'sl', toggle_virtual_text)
-- vim.keymap.set('n', 'sd', toggle_diagnostics)
vim.keymap.set('n', 'si', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
-- vim.keymap.set('n', 'sdd', vim.diagnostic.setloclist)

local function show_hover()
   local diagnostics = vim.diagnostic.get(0, { lnum = vim.api.nvim_win_get_cursor(0)[1] - 1 })

   if #diagnostics > 0 then
      vim.diagnostic.open_float(nil, { focusable = false, scope = "line" })
   else
      vim.lsp.buf.hover()
   end
end

vim.keymap.set('n', 'sh', show_hover)

local function jump_into_hover_window()
   vim.lsp.buf.hover()
   vim.lsp.buf.hover()
end

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions

    local opts = { buffer = ev.buf }


    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    -- vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    -- vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)

    -- vim.keymap.set('n', 'sh', jump_into_hover_window, opts)
    vim.keymap.set('n', 'crn', vim.lsp.buf.rename, opts)
    vim.keymap.set({ 'n', 'v' }, 'caa', vim.lsp.buf.code_action, opts)

    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    -- vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    -- vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)

    -- vim.keymap.set('n', 'sh', jump_into_hover_window, opts)
    -- vim.keymap.set('n', 'crn', vim.lsp.buf.rename, opts)

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

