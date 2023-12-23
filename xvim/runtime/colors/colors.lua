
-- If you think you have a color scheme that is good enough to be used by others,
-- please check the following items:

-- - Source the $VIMRUNTIME/colors/tools/check_colors.vim script to check for common mistakes.

-- - Does it work in a color terminal as well as in the GUI? Is it consistent?

-- x Is 'background' either used or appropriately set to "light" or "dark"?

-- x Try setting 'hlsearch' and searching for a pattern, is the match easy to spot?

-- - Split a window with ":split" and ":vsplit".  Are the status lines and vertical separators clearly visible?

-- - In the GUI, is it easy to find the cursor, also in a file with lots of syntax highlighting?

-- - In general, test your color scheme against as many filetypes, Vim features, environments, etc. as possible.

-- - Do not use hard coded escape sequences, these will not work in other terminals.  Always use #RRGGBB for the GUI.

-- - When targetting 256 colors terminals, prefer colors 16-255 to colors 0-15 for the same reason.

-- / Typographic attributes (bold, italic, underline, reverse, etc.) are not universally supported.  Don't count on any of them.

-- TODO: look into this function, is it good?

-- local colors = {
--    bg = '#282c34',
--    fg = '#abb2bf',
--    red = '#e06c75',
--    green = '#98c379',
--    blue = '#61afef',
--    yellow = '#e5c07b'
-- }

-- local function set_highlight(group, color)
--    local style = color.style and "gui=" .. color.style or "gui=NONE"
--    local fg = color.fg and "guifg=" .. color.fg or "guifg=NONE"
--    local bg = color.bg and "guibg=" .. color.bg or "guibg=NONE"
--    vim.api.nvim_set_hl(0, group, { fg = color.fg, bg = color.bg, bold = color.bold, italic = color.italic })
-- end

-- set_highlight('Normal', { fg = colors.fg, bg = colors.bg })
-- set_highlight('Comment', { fg = colors.blue, italic = true })

-- js:
-- null, return, await, args, this.
-- string single, double, ``
-- prototype, defer?
-- noise, null, undefined, typeof, true, false
-- numbers, brackets, parents, object key
-- comment TODO, HACK
-- add keywords: self.
-- single character
-- template string, template var
-- keywords should be in italics
-- strings should be italic

-- find markdown syntax setup

-- this doesn't seem to work.
-- vim.o.termguicolors = true


-- TODO: write a function to do the colors, so you can easily support gui colors

local red = {
   l = { ctermfg = x },
   m = { ctermfg = x },
   h = { ctermfg = x },
   bg = {
      l = { ctermbg = x },
      m = { ctermbg = x },
      h = { ctermbg = x },
   }
}

local orange = {
   l = { ctermfg = x },
   m = { ctermfg = x },
   h = { ctermfg = x },
   bg = {
      l = { ctermbg = x },
      m = { ctermbg = x },
      h = { ctermbg = x },
   }
}

local yellow = {
   l = { ctermfg = x },
   m = { ctermfg = x },
   h = { ctermfg = x },
   bg = {
      l = { ctermbg = x },
      m = { ctermbg = x },
      h = { ctermbg = x },
   }
}

local green = {
   l = { ctermfg = x },
   m = { ctermfg = x },
   h = { ctermfg = x },
   bg = {
      l = { ctermbg = x },
      m = { ctermbg = x },
      h = { ctermbg = x },
   }
}

local blue = {
   l = { ctermfg = x },
   m = { ctermfg = x },
   h = { ctermfg = x },
   bg = {
      l = { ctermbg = x },
      m = { ctermbg = x },
      h = { ctermbg = x },
   }
}

local violet = {
   l = { ctermfg = x },
   m = { ctermfg = x },
   h = { ctermfg = x },
   bg = {
      l = { ctermbg = x },
      m = { ctermbg = x },
      h = { ctermbg = x },
   }
}

local test_color = {
   ctermfg = 166,
   bold = true,
   italic = true,
   -- cterm = { italic = true },
   -- standout = true,
   -- underline = true,
   -- undercurl = true,
   -- underdouble = true,
   -- blend = 50 , -- integer between 0 and 100
   -- blend = 0 , -- integer between 0 and 100
   -- underdotted = true,
   -- underdashed = true,
   -- strikethrough = true,
   -- reverse = true,
   -- nocombine = true,
   -- link = "some_hl_group" -- name of another highlight group to link to, see :hi-link.
   -- default = true
   -- ctermfg = Sets foreground of cterm color ctermfg
   -- ctermbg = Sets background of cterm color ctermbg
   -- cterm = cterm attribute map, like highlight-args. If not set, cterm attributes will match those from the attribute map documented above.
   -- force = if true force update the highlight group when it exists.
}


local links = {
  ['@lsp.type.namespace'] = '@namespace',
  ['@lsp.type.type'] = '@type',
  ['@lsp.type.class'] = '@type',
  ['@lsp.type.enum'] = '@type',
  ['@lsp.type.interface'] = '@type',
  ['@lsp.type.struct'] = '@structure',
  ['@lsp.type.parameter'] = '@parameter',
  ['@lsp.type.variable'] = '@variable',
  ['@lsp.type.property'] = '@property',
  ['@lsp.type.enumMember'] = '@constant',
  ['@lsp.type.function'] = '@function',
  ['@lsp.type.method'] = '@method',
  ['@lsp.type.macro'] = '@macro',
  ['@lsp.type.decorator'] = '@function',
}

for newgroup, oldgroup in pairs(links) do
  vim.api.nvim_set_hl(0, newgroup, { link = oldgroup, default = true })
end

-- vim.api.nvim_set_hl(0, '@lsp.type.parameter', { fg='Purple' })
-- vim.api.nvim_set_hl(0, '@variable.javascript', { ctermfg=61})
-- vim.api.nvim_set_hl(0, '@variable.javascript', blue)
-- vim.api.nvim_set_hl(0, '@variable.javascript', { ctermfg=125})

vim.api.nvim_set_hl(0, '@keyword.javascript', { italic = true })
vim.api.nvim_set_hl(0, '@conditional.javascript', { italic = true })
vim.api.nvim_set_hl(0, '@function.javascript', { italic = true })
vim.api.nvim_set_hl(0, '@keyword.function.javascript', { italic = true })

-- vim.api.nvim_set_hl(0, '@function', orange)
-- vim.api.nvim_set_hl(0, '@lsp.mod.local.javascript', orange)
-- vim.api.nvim_set_hl(0, '@function', blue)

-- hop highlights

local red = 160
local yellow = 190
local orange = 208
local pink = 201
local teal = 45
local dark_teal = 33

vim.api.nvim_set_hl(0, 'HopNextKey', { fg = '#ff007c', bold = true, ctermfg = yellow, cterm = { bold = true } })
vim.api.nvim_set_hl(0, 'HopNextKey1', { fg = '#00dfff', bold = true, ctermfg = red, cterm = { bold = true } })
vim.api.nvim_set_hl(0, 'HopNextKey2', { fg = '#2b8db3', ctermfg = dark_teal })
vim.api.nvim_set_hl(0, 'HopUnmatched', { fg = '#666666', sp = '#666666', ctermfg = 242 })
vim.api.nvim_set_hl(0, 'HopCursor', { link = 'Cursor' })
vim.api.nvim_set_hl(0, 'HopPreview', { link = 'IncSearch' })

-- this is for trailing space and tabs. basically all listchars.
vim.api.nvim_set_hl(0, 'NonText', { ctermfg = red })
vim.api.nvim_set_hl(0, 'SpecialKey', { ctermfg = red })


local black = 232
local menu_bg = 234
local select_bg = 233
-- local menu_fg = 249
local menu_fg = 246  -- this keeps the autocomplete menu a little more chill
local select_fg = 'white'
-- 'white', 'darkblue'
-- local menu_bg = 33
-- local menu_fg = 254
local fg_orange = 1
local border_bg = black
local border_fg = 241
local title_fg = 244

-- Setting highlights
vim.api.nvim_set_hl(0, "FloatBorder", { ctermbg = menu_bg, ctermfg = menu_fg })
vim.api.nvim_set_hl(0, "FloatTitle", { ctermbg = menu_bg, ctermfg = menu_fg })
vim.api.nvim_set_hl(0, "Pmenu", { ctermbg = menu_bg, ctermfg = menu_fg })
vim.api.nvim_set_hl(0, "PmenuSel", { ctermbg = menu_fg, ctermfg = menu_bg })
-- vim.api.nvim_set_hl(0, "PmenuKind", { ctermbg = bg_color, ctermfg = fg_orange })
-- vim.api.nvim_set_hl(0, "PmenuKindSel", { ctermbg = bg_color, ctermfg = fg_orange })
-- vim.api.nvim_set_hl(0, "PmenuExtra", { ctermbg = bg_color, ctermfg = fg_orange })
-- vim.api.nvim_set_hl(0, "PmenuExtraSel", { ctermbg = bg_color, ctermfg = fg_orange })
-- vim.api.nvim_set_hl(0, "PmenuSbar", { ctermbg = bg_color, ctermfg = fg_orange })
-- vim.api.nvim_set_hl(0, "PmenuThumb", { ctermbg = bg_color, ctermfg = fg_orange })


local vertsplit_fg = 236;

-- set fill char to non-breaking space (it's there between the ' '', it's not a normal space) 
-- since we set the statusbar colors the same below it'll add ^^^ to the status line because it doesn't know anything about lightline
vim.opt.fillchars = { stl = ' ' }

vim.api.nvim_set_hl(0, 'VertSplit', { ctermfg = vertsplit_fg, ctermbg = vertsplit_fg })
vim.api.nvim_set_hl(0, 'StatusLine', { ctermfg = vertsplit_fg, ctermbg = vertsplit_fg })
vim.api.nvim_set_hl(0, 'StatusLineNC', { ctermfg = vertsplit_fg, ctermbg = vertsplit_fg })

local yank_group = vim.api.nvim_create_augroup("highlight_yank", { clear = true })

vim.api.nvim_create_autocmd("TextYankPost", {
    group = yank_group,
    pattern = "*",
    callback = function()
        vim.highlight.on_yank({ higroup = "IncSearch", timeout = 200 })
    end,
})

-- black gutter for line numbers
vim.api.nvim_set_hl(0, 'LineNr', { ctermfg = 238 })
vim.api.nvim_set_hl(0, 'TabLine', { ctermfg = 245, ctermbg = "none", underline = true })
vim.api.nvim_set_hl(0, 'TabLineFill', { ctermbg = "none", underline = true })

-- these are changes for solarized
vim.api.nvim_set_hl(0, 'MatchParen', { ctermfg=136, ctermbg = "none", bold = true })

vim.api.nvim_set_hl(0, 'CursorLine', { ctermbg = 235 })

-- vim.wo.cursorcolumn = true
-- vim.api.nvim_set_hl(0, "CursorColumn", { ctermbg="darkred", ctermfg="white" })


-- -- a little lighter than the default 241. wish there was an in between
-- vim.api.nvim_set_hl(0, 'Comment', { ctermfg = 242 }) -- Name:     Solarized vim colorscheme

vim.opt.signcolumn = 'yes'
vim.api.nvim_set_hl(0, 'SignColumn', {})

-- vim.fn.sign_define('DiagnosticSignError', { text = '⚠', texthl = 'DiagnosticSignError' })
vim.fn.sign_define('DiagnosticSignError', { text = 'E', texthl = 'DiagnosticSignError' })
vim.fn.sign_define('DiagnosticSignWarn', { text = 'W', texthl = 'DiagnosticSignWarn' })
vim.fn.sign_define('DiagnosticSignInfo', { text = 'I', texthl = 'DiagnosticSignInfo' })
vim.fn.sign_define('DiagnosticSignHint', { text = 'H', texthl = 'DiagnosticSignHint' })

local function disable_all_highlight_groups()
   -- Retrieve list of all highlight groups
   local highlight_groups = vim.api.nvim_get_hl(0, { link = true })

   -- Iterate and disable each group
   for group, info in pairs(highlight_groups) do
      if not info.link then
         vim.print(group)
         vim.print(info)
      end
      -- vim.api.nvim_set_hl(0, group, { link = '' })
   end
end

-- Call the function to disable all highlight groups
-- disable_all_highlight_groups()

local function disable_lsp_and_treesitter()
   -- Disabling LSP diagnostics
   vim.diagnostic.disable()

   -- Disabling LSP for the current buffer
   local clients = vim.lsp.get_active_clients()
   if clients then
      for _, client in ipairs(clients) do
         vim.lsp.buf_detach_client(0, client.id)
      end
   end

   -- Disabling Tree-sitter highlighting
   vim.cmd("TSBufDisable highlight")
end

-- disable_lsp_and_treesitter()

vim.keymap.set('n', 'sz', disable_lsp_and_treesitter)
