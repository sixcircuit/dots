
local mode_maps = {}

mode_maps[3] = {
   ['n']     = 'NOR', -- Normal
   ['no']    = 'NOP', -- Operator-pending
   ['nov']   = 'NOV', -- Operator-pending (forced charwise |o_v|)
   ['noV']   = 'NOV', -- Operator-pending (forced linewise |o_V|)
   ['no\22'] = 'NOB', -- Operator-pending (forced blockwise |o_CTRL-V|)
   ['niI']   = 'NII', -- Normal using |i_CTRL-O| in |Insert-mode|
   ['niR']   = 'NIR', -- Normal using |i_CTRL-O| in |Replace-mode|
   ['niV']   = 'NIV', -- Normal using |i_CTRL-O| in |Virtual-Replace-mode|
   ['v']     = 'VIS', -- Visual by character
   ['V']     = 'VLN', -- Visual by line
   ['\22']   = 'VBL', -- Visual blockwise
   ['s']     = 'SLC', -- Select by character
   ['S']     = 'SLN', -- Select by line
   ['\19']   = 'SBL', -- Select blockwise
   ['i']     = 'INS', -- Insert
   ['ic']    = 'INC', -- Insert mode completion |compl-generic|
   ['ix']    = 'INX', -- Insert mode |i_CTRL-X| completion
   ['R']     = 'RPL', -- Replace |R|
   ['Rc']    = 'RPC', -- Replace mode completion |compl-generic|
   ['Rv']    = 'RVR', -- Virtual Replace |gR|
   ['Rx']    = 'RRX', -- Replace mode |i_CTRL-X| completion
   ['c']     = 'CMD', -- Command-line editing
   ['cv']    = 'EXM', -- Vim Ex mode |gQ|
   ['ce']    = 'EXN', -- Normal Ex mode |Q|
   ['r']     = 'HIT', -- Hit-enter prompt
   ['rm']    = 'MOR', -- The -- more -- prompt
   ['r?']    = 'CNF', -- A |:confirm| query of some sort
   ['!']     = 'SHL', -- Shell or external command is executing
   ['t']     = 'TRM'  -- Terminal mode
}

mode_maps[4] = {
   ['n']     = 'NORM', -- Normal
   ['no']    = 'NOPD', -- Operator-pending
   ['nov']   = 'NOVC', -- Operator-pending (forced charwise |o_v|)
   ['noV']   = 'NOVL', -- Operator-pending (forced linewise |o_V|)
   ['no\22'] = 'NOVB', -- Operator-pending (forced blockwise |o_CTRL-V|)
   ['niI']   = 'NIIN', -- Normal using |i_CTRL-O| in |Insert-mode|
   ['niR']   = 'NIRE', -- Normal using |i_CTRL-O| in |Replace-mode|
   ['niV']   = 'NIVR', -- Normal using |i_CTRL-O| in |Virtual-Replace-mode|
   ['v']     = 'VISC', -- Visual by character
   ['V']     = 'VISL', -- Visual by line
   ['\22']   = 'VISB', -- Visual blockwise
   ['s']     = 'SELC', -- Select by character
   ['S']     = 'SELL', -- Select by line
   ['\19']   = 'SELB', -- Select blockwise
   ['i']     = 'INSR', -- Insert
   ['ic']    = 'INSC', -- Insert mode completion |compl-generic|
   ['ix']    = 'INSX', -- Insert mode |i_CTRL-X| completion
   ['R']     = 'REPL', -- Replace |R|
   ['Rc']    = 'REPC', -- Replace mode completion |compl-generic|
   ['Rv']    = 'REPV', -- Virtual Replace |gR|
   ['Rx']    = 'REPX', -- Replace mode |i_CTRL-X| completion
   ['c']     = 'CMMD', -- Command-line editing
   ['cv']    = 'EXMD', -- Vim Ex mode |gQ|
   ['ce']    = 'EXNM', -- Normal Ex mode |Q|
   ['r']     = 'HENT', -- Hit-enter prompt
   ['rm']    = 'MORE', -- The -- more -- prompt
   ['r?']    = 'CONF', -- A |:confirm| query of some sort
   ['!']     = 'SHLL', -- Shell or external command is executing
   ['t']     = 'TERM'  -- Terminal mode
}

mode_maps[5] = {
   ['n']     = 'NORML', -- Normal
   ['no']    = 'NOPND', -- Operator-pending
   ['nov']   = 'NOPVC', -- Operator-pending (forced charwise |o_v|)
   ['noV']   = 'NOPVL', -- Operator-pending (forced linewise |o_V|)
   ['no\22'] = 'NOPVB', -- Operator-pending (forced blockwise |o_CTRL-V|)
   ['niI']   = 'NIIOM', -- Normal using |i_CTRL-O| in |Insert-mode|
   ['niR']   = 'NIROM', -- Normal using |i_CTRL-O| in |Replace-mode|
   ['niV']   = 'NIVRM', -- Normal using |i_CTRL-O| in |Virtual-Replace-mode|
   ['v']     = 'VISCH', -- Visual by character
   ['V']     = 'VISLN', -- Visual by line
   ['\22']   = 'VISBL', -- Visual blockwise
   ['s']     = 'SELCH', -- Select by character
   ['S']     = 'SELLN', -- Select by line
   ['\19']   = 'SELBL', -- Select blockwise
   ['i']     = 'INSRT', -- Insert
   ['ic']    = 'INSCM', -- Insert mode completion |compl-generic|
   ['ix']    = 'INSXC', -- Insert mode |i_CTRL-X| completion
   ['R']     = 'REPLC', -- Replace |R|
   ['Rc']    = 'REPRC', -- Replace mode completion |compl-generic|
   ['Rv']    = 'REPRV', -- Virtual Replace |gR|
   ['Rx']    = 'REPRX', -- Replace mode |i_CTRL-X| completion
   ['c']     = 'CMDLN', -- Command-line editing
   ['cv']    = 'EXMOD', -- Vim Ex mode |gQ|
   ['ce']    = 'EXNMD', -- Normal Ex mode |Q|
   ['r']     = 'HITEN', -- Hit-enter prompt
   ['rm']    = 'MORE-', -- The -- more -- prompt
   ['r?']    = 'CONF-', -- A |:confirm| query of some sort
   ['!']     = 'SHELL', -- Shell or external command is executing
   ['t']     = 'TERML'  -- Terminal mode
}
local colorscheme = 'mine'

local colors = {}

colors.normal = {
   left = { {'darkestgreen', 'brightgreen', 'bold'}, {'white', 'gray4'} },
   middle = { {'gray7', 'gray2'} },
   right = { {'gray5', 'gray10'}, {'gray9', 'gray4'}, {'gray8', 'gray2'} },
   error = { {'gray9', 'brightestred'} },
   warning = { {'gray1', 'yellow'} }
}

colors.inactive = {
   right = { {'gray1', 'gray5'}, {'gray4', 'gray1'}, {'gray4', 'gray0'} },
   left = { {'235', '235'}, {'gray7', 'gray2'} },
   middle = { {'orange', 'gray0'} }
}

colors.insert = {
   left = { {'darkestcyan', 'white', 'bold'}, {'white', 'darkblue'} },
   middle = { {'mediumcyan', 'darkestblue'} },
   right = { {'darkestcyan', 'mediumcyan'}, {'mediumcyan', 'darkblue'}, {'mediumcyan', 'darkestblue'} }
}

colors.replace = {
   left = { {'white', 'brightred', 'bold'}, {'white', 'gray4'} },
   middle = colors.normal.middle,
   right = colors.normal.right
}

colors.visual = {
   left = { {'darkred', 'brightorange', 'bold'}, {'white', 'gray4'} }
}

colors.tabline = {
   left = { {'gray9', 'gray4'} },
   tabsel = { {'gray9', 'gray1'} },
   middle = { {'gray2', 'gray8'} },
   right = { {'gray9', 'gray3'} }
}


local function gutter_width()
   local num_col_width = 0
   local sign_col_width = 0

   if vim.wo.number or vim.wo.relativenumber then
      local max_number = vim.api.nvim_buf_line_count(0)
      local num_digits = string.len(tostring(max_number))
      local numberwidth = vim.o.numberwidth

      -- Use the larger of (num_digits + 1) (for space) or numberwidth (which already has +1 for space)
      num_col_width = math.max(num_digits + 1, numberwidth)
   end

   -- Check and calculate sign column width
   -- Assuming maximum sign column width is 2
   -- This might need to be adjusted based on your setup
   local signs = vim.fn.sign_getdefined()
   if #signs > 0 then
      sign_col_width = 2
   end

   return num_col_width + sign_col_width
end


local function has_diagnostics()
   local diagnostics = vim.diagnostic.get(0)  -- 0 for the current buffer
   return #diagnostics > 0
end

local function color_for_mode(prefix, suffix)

   local mode_map = { V = 'n', ['\22'] = 'n', s = 'n', v = 'n', ['\19'] = 'n', c = 'n', R = 'n' }

   local insert_hl = vim.api.nvim_get_hl(0, { name = prefix .. '_insert_' .. suffix })
   local normal_hl = vim.api.nvim_get_hl(0, { name = prefix .. '_normal_' .. suffix })

   local color_map = {
      n = normal_hl,
      i = insert_hl
   }

   local current_mode = vim.api.nvim_get_mode().mode:sub(1, 1)

   local mode = mode_map[current_mode] or current_mode

   local color = color_map[mode]

   return color

end

local function hl_for_indicator_char()
   return color_for_mode('LightlineLeft', "1")
end

local color = {}

color.red = {
   term = 160,
   gui = "#d70000",
   h = {
      term = 196,
      gui = "#ff0000"
   }
}

local indicator_char_fg_color = color.red.h

local function set_indicator_hl(name)
   local bg_color = hl_for_indicator_char()

   vim.api.nvim_set_hl(0, name, {
      fg = indicator_char_fg_color.gui,
      bg = bg_color.bg,
      ctermfg = indicator_char_fg_color.term,
      ctermbg = bg_color.ctermbg,
      bold = true,
   })

end

function LightlineReadOnly()
   set_indicator_hl("LightlineReadOnlyColor")
   return vim.bo.readonly and "RO " or ""
end

function LightlineModified()
   set_indicator_hl("LightlineModifiedColor")
   return vim.bo.modified and "• " or ""
end

function LightlineDiagnostics()
   set_indicator_hl("LightlineDiagnosticsColor")
   return has_diagnostics() and  "‼ " or ""
end

function LightlineFileName()
   local fname = vim.fn.expand('%:t')
   if fname == 'ControlP' and vim.g.lightline and vim.g.lightline.ctrlp_item then
      return vim.g.lightline.ctrlp_item
   elseif fname == 'Command-T [Files]' then
      return vim.fn['commandt#Path']()
   elseif fname == '__Tagbar__' then
      return vim.g.lightline.fname
   elseif string.find(fname, '__Mundo') or string.find(fname, 'NERD_tree') then
      return ''
   elseif vim.bo.filetype == 'vimfiler' then
      return vim.fn['vimfiler#get_status_string']()
   elseif vim.bo.filetype == 'unite' then
      return vim.fn['unite#get_status_string']()
   elseif vim.bo.filetype == 'vimshell' then
      return vim.fn['vimshell#get_status_string']()
   else
      return fname ~= '' and vim.fn.expand('%') or '[No Name]'
   end
end

local function width_check(value_f)
   return function()
      if vim.api.nvim_win_get_width(0) > 90 then
         return value_f() or ""
      else
         return ""
      end
   end
end

local function to_fixed(number, digits)
    local formatString = "%." .. digits .. "f"
    return string.format(formatString, number)
end

local function left_pad(str, len, pad_char)
   str = tostring(str)
   pad_char = pad_char or ' '  -- Default padding character is a space if not provided
   if #str < len then
      return string.rep(pad_char, len - #str) .. str
   else
      return str
   end
end

LightlineWordCount = width_check(function()
   local wc = vim.fn.wordcount()

   local word_total = tostring(wc.words)
   local word_count = ""
   local percent = ""
   -- percent = left_pad(percent, 2)
   -- local percent = left_pad(tostring(math.floor((wc.cursor_words/wc.words)*1000)/10), 4)
   -- local percent = left_pad(tostring(math.floor(((wc.cursor_words/wc.words)*100)), 2)

   if wc.visual_words then
      word_count = wc.visual_words
      percent = to_fixed(((wc.visual_words/wc.words)*1000)/10, 1)
   else
      word_count = wc.cursor_words
      percent = to_fixed(((wc.cursor_words/wc.words)*1000)/10, 1)
   end

   percent = left_pad(percent, 4)
   local word_count_str = left_pad(tostring(word_count), #word_total)

   if percent == "100.0" then
      -- return word_count_str.."/"..word_total.." [99.9%]"
      return word_count_str.."/"..word_total.." [00.0%]"
   else
      return word_count_str.."/"..word_total.." ["..percent.."%]"
   end
end)

LightlineFugitive = width_check(function()
   local status, branch = pcall(vim.fn["fugitive#Head"])
   if status and branch ~= "" then
      local mark_prefix = "git["  -- edit here for cool mark
      local mark_suffix = "]"  -- edit here for cool mark
      return mark_prefix .. branch .. mark_suffix
   end
end)

LightlineFileFormat = width_check(function()
   return vim.bo.fileformat
end)

LightlineFileType = width_check(function()
   return vim.bo.filetype ~= "" and vim.bo.filetype or "no ft"
end)

LightlineFileEncoding = width_check(function()
   return vim.bo.fenc ~= "" and vim.bo.fenc or vim.o.enc
end)

local function lightline_mode(inactive)
   local fname_map = {
      ['__Mundo__'] = 'Mundo',
      ['__Mundo_Preview__'] = 'Mundo',
   }

   local ft_map = {
      ['vimshell'] = 'VimShell',
   }

   local fname = vim.fn.expand('%:t')
   local filetype = vim.bo.filetype

   if fname_map[fname] then
      return fname_map[fname]
   elseif ft_map[filetype] then
      return ft_map[filetype]
   end

   local mode_len = (gutter_width() - 3) -- subtract 2 for the padding around the mode, and 1 for the extra space next to numbers

   -- print("#modemaps: ", #mode_maps)

   local mode_map = mode_maps[mode_len]

   if not mode_map then
      mode_map = mode_maps[#mode_maps]
   end

   local mode_str = mode_map[vim.fn.mode()] or string.rep("?", mode_len)

   if inactive then
      return string.rep(" ", #mode_str)
   else
      return mode_str
   end

end

function LightlineModeActive()
   return lightline_mode(false)
end

function LightlineModeInactive()
   return lightline_mode(true)
end

LightlineClock = width_check(function()
   local hour = vim.fn.strftime('%H')

   hour = tonumber(hour)

   local line_color = color_for_mode('LightlineRight', "2")
   local clock_color = line_color;

   if hour < 8 or hour > 21 then
      clock_color.fg = color.red.h.gui
      clock_color.ctermfg = color.red.h.term
   end

   vim.api.nvim_set_hl(0, "LightlineClockColor", clock_color)

   return (" " .. vim.fn.strftime('%H:%M') .. "  ")
   -- return (" " .. vim.fn.strftime('%H:%M:%S') .. "  ")
end)


vim.api.nvim_set_var('LightlineModeActive', LightlineModeActive)
vim.api.nvim_set_var('LightlineModeInactive', LightlineModeInactive)
vim.api.nvim_set_var('LightlineReadOnly', LightlineReadOnly)
vim.api.nvim_set_var('LightlineModified', LightlineModified)
vim.api.nvim_set_var('LightlineDiagnostics', LightlineDiagnostics)
vim.api.nvim_set_var('LightlineFileName', LightlineFileName)
vim.api.nvim_set_var('LightlineFileFormat', LightlineFileFormat)
vim.api.nvim_set_var('LightlineFileType', LightlineFileType)
vim.api.nvim_set_var('LightlineFileEncoding', LightlineFileEncoding)
vim.api.nvim_set_var('LightlineFugitive', LightlineFugitive)
vim.api.nvim_set_var('LightlineClock', LightlineClock)
vim.api.nvim_set_var('LightlineWordCount', LightlineWordCount)

vim.api.nvim_exec([[
  function! UpdateClock()
    call lightline#update()
  endfunction
]], false)


local function lightline_setup()

   -- we only support numberwidth 4 or higher 
   vim.o.numberwidth = math.max(vim.o.numberwidth, 4)

   -- vim.o.numberwidth = 4 --   (to 999)
   -- vim.o.numberwidth = 5 --  (to 9999)
   -- vim.o.numberwidth = 6 -- (to 99999)

   vim.g['lightline#colorscheme#mine#palette'] = vim.fn['lightline#colorscheme#fill'](colors)

   vim.g.lightline = {
      colorscheme = colorscheme,
      enable = { tabline = 0 },
      separator = { left = '', right = '' },
      subseparator = { left = '', right = '' },
      active = {
         left = { { 'mode_active', 'paste' }, { 'filename', 'modified', 'diagnostics', 'readonly' } },
         right = { {'lineinfo'}, {'word_count'}, { 'fileformat', 'fileencoding', 'filetype', 'fugitive', 'clock' } }
         -- right = { {'lineinfo'}, {'percent', 'word_count'}, { 'fileformat', 'fileencoding', 'filetype', 'fugitive', 'clock' } }
         -- right = { {'lineinfo'}, {'word_count', 'percent' }, { 'fileformat', 'fileencoding', 'filetype', 'fugitive', 'clock' } }
      },
      inactive = {
         left = { { 'mode_inactive' }, { 'filename' } },
         right = { { 'lineinfo' }, { 'percent' } }
      },
      tabline = {
         left = { {'tabs'} },
         right = { {'close'} }
      },
      tab = {
         active = { 'tabnum', 'filename', 'modified', 'diagnostics' },
         inactive = { 'tabnum', 'filename', 'modified', 'diagnostics' }
      },
      component = {
         modified = '%#LightlineModifiedColor#%{LightlineModified()}',
         diagnostics = '%#LightlineDiagnosticsColor#%{LightlineDiagnostics()}',
         readonly = '%#LightlineReadOnlyColor#%{LightlineReadOnly()}',
         clock = '%#LightlineClockColor#%{LightlineClock()}',
      },
      component_type = {
         modified = 'raw',
         diagnostics = 'raw',
         readonly = 'raw',
         clock = 'raw'
      },
      component_function = {
         word_count = 'LightlineWordCount',
         mode_active = 'LightlineModeActive',
         mode_inactive = 'LightlineModeInactive',
         filename = 'LightlineFileName',
         fileformat = 'LightlineFileFormat',
         filetype = 'LightlineFileType',
         fileencoding = 'LightlineFileEncoding',
         fugitive = 'LightlineFugitive',
      },
   }

   if not _G.clock_timer then
      _G.clock_timer = vim.loop.new_timer()
      _G.clock_timer:start(0, 1000, vim.schedule_wrap(function()
        vim.api.nvim_command('call UpdateClock()')
      end))
   end

end

lightline_setup()

