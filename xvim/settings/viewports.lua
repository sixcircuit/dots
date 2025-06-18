
vim.o.splitbelow = true
vim.o.splitright = true

-- TODO: refactor this.

-- vim.api.nvim_create_autocmd({"BufLeave", "BufDelete"}, {
--    callback = function()
--       vim.cmd(":layout_windows")
--    end
-- })

local function switch_to_window(win_index)
   vim.api.nvim_exec(win_index .. "wincmd w", false)
   vim.defer_fn(function()
      vim.cmd("normal! zH")
   end, 10)
end

local function switch_to_next_window()
   vim.api.nvim_exec("wincmd w", false)
end

local function rotate_panes()
   vim.api.nvim_exec("wincmd r", false)
end

local function split_window()
   vim.api.nvim_exec('vs', false)
end

local function resize_current_window(size)
   vim.api.nvim_exec('vertical resize ' .. size, false)
end

local function resize_window(win_index, size)
    local cur_win = vim.api.nvim_get_current_win()
    switch_to_window(win_index)
    resize_current_window(size)
    vim.api.nvim_set_current_win(cur_win)
end


-- first split is math.ceil(columns * 0.29)
local function layout_windows(adjust_left)
   if adjust_left == nil then
      adjust_left = 0
   end
   local cur_win = vim.api.nvim_get_current_win()
   local cur_win_width = vim.api.nvim_win_get_width(cur_win)
   local all_cols = vim.o.columns
   local panes = vim.fn.winnr('$')


   local first_split_big = 83 + adjust_left -- same as = on big screen (for 17 font size)

   -- local first_split_big = 93 " same as = on big screen (for 15 font size)
   -- local second_split_big = 100

   -- terminal windows - 10

   if all_cols <= 250 then -- laptop screens
      local first_split_small = 50
      local second_split_small = 85

      if all_cols <= 150 then
         first_split_small = 35
         second_split_small = 85
      end

      first_split_small = first_split_small + adjust_left

      if panes == 1 then
         split_window()
         switch_to_window(2)
         resize_window(1, first_split_small)

      elseif panes == 2 then
         resize_window(1, first_split_small)

      elseif panes == 3 then
         resize_window(1, first_split_small)
         resize_window(2, second_split_small)
      else
         vim.api.nvim_exec("wincmd =", false)
      end
   else  -- big screen
      if panes == 1 then
         split_window()
         switch_to_window(2)
         resize_window(1, first_split_big)

      elseif panes == 2 then
         resize_window(1, first_split_big)

      elseif panes == 3 then
         vim.api.nvim_exec("wincmd =", false)
         -- resize_window(1, first_split_big)
         -- resize_window(2, second_split_big)

      else
         vim.api.nvim_exec("wincmd =", false)
      end
   end
end

-- TODO: i'd like this to be smart and rotate till i'm at a new file.
-- i keep a, b, b open for the 3 column layout. and i'd like to switch between
-- a or b and stay in the center
local function rotate_windows_keep_cursor()
    local cur_win = vim.fn.winnr()
    local panes = vim.fn.winnr('$')

    -- if panes == 2
       rotate_panes()
       switch_to_window(cur_win)
       layout_windows()
    -- elseif panes == 3
    --    rotate_panes()
    --    rotate_panes()
    --    switch_to_window(cur_win)
    -- elseif panes == 4
    --    rotate_panes()
    --    rotate_panes()
    --    rotate_panes()
    --    switch_to_window(cur_win)
    -- end

end

_G.layout_windows = layout_windows
_G.rotate_windows_keep_cursor = rotate_windows_keep_cursor

-- Rotate Windows and Keep Cursor
vim.keymap.set('n', '<space>r', rotate_windows_keep_cursor, { silent = true })
vim.keymap.set('n', '<space>e', layout_windows, { silent = true })

-- Tab navigation
vim.keymap.set('n', '<m-h>', ':tabp<CR>')
vim.keymap.set('n', '<m-l>', ':tabn<CR>')
vim.keymap.set('n', '<m-p>', ':tabm -1<CR>')
vim.keymap.set('n', '<m-t>', ':tabm +1<CR>')

-- navigate windows easily
vim.keymap.set('n', '<m-n>', '<C-w>w')

-- scroll setup


-- scroll the viewport faster with ctrl-j and ctrl-k
vim.keymap.set('', '<m-k>', '5<c-y>')
vim.keymap.set('', '<m-j>', '5<c-e>')
vim.keymap.set('', '<m-u>', "18<c-u>")
vim.keymap.set('', '<m-d>', "18<c-d>")

local function feedkeys(keys)
   keys = vim.api.nvim_replace_termcodes(keys, true, false, true)
   vim.api.nvim_feedkeys(keys, "n", false)
end

local function big_scroll(dir, factor)
   if factor == nil then factor = 0.4 end

   return function()
      local win_height = vim.api.nvim_win_get_height(0)
      local buf_line_count = vim.api.nvim_buf_line_count(0)
      local cursor_line = vim.fn.line(".")
      local scrolloff = vim.o.scrolloff
      local scroll_lines = math.floor(win_height * factor)

      if dir == "d" then
         if cursor_line < scrolloff then
            feedkeys(scrolloff .. "G")
            return
         end
      else -- dir == "u"
         local threshold = buf_line_count - scrolloff
         if cursor_line > threshold then
            feedkeys(threshold .. "G")
            return
         end
      end

      feedkeys(scroll_lines .. "<c-" .. dir .. ">")
   end
end

vim.keymap.set('n', '<M-u>', big_scroll("u"))
vim.keymap.set('n', '<M-d>', big_scroll("d"))
-- vim.keymap.set('n', '<M-space>', big_scroll("d", 0.7))

local function comfy_cursor()
   local n_rows = vim.api.nvim_win_get_height(0)
   -- the weird execute normal thing does it all before a draw (which feedkeys doesn't)
   -- so we don't get a flicker if we just hammer on zz like we would with feedkeys

   local current_line = vim.fn.line(".")
   local max_scroll = 10  -- how far down we’d normally scroll
   local min_required = 5 -- how many lines from the top we tolerate before scrolling

   if current_line <= min_required then
      -- We're too close to the top — just regular centering
      vim.cmd('normal! zz')
      return
   end

   if n_rows < 20 then
      vim.cmd('execute "normal! zz"')
   elseif n_rows <= 50 then
      vim.cmd('execute "normal! zz8\\<c-e>"') -- move line to top middle. (on a laptop screen)
   else
      vim.cmd('execute "normal! zz10\\<c-e>"') -- move line to top middle. (on a big screen)
   end
end


vim.keymap.set('n', 'zz', comfy_cursor, { desc = "smart zz" })



