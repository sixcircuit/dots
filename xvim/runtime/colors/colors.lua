
local link = {}

link.norm = { link = "Normal" }

local color = {}

color.gray = {
   ll = { term = 235, gui = "#262626" },
   l  = { term = 237, gui = "#3a3a3a" },
   ml = { term = 241, gui = "#626262" },
   m  = { term = 245, gui = "#8a8a8a" },
   mh = { term = 247, gui = "#9e9e9e" },
   h  = { term = 249, gui = "#b2b2b2" },
   hh = { term = 251, gui = "#c6c6c6" },
}

color.bg = {
   term = 16,
   gui = "#000000"
}

color.fg = color.gray.mh

color.gold = {
   term = 136,
   gui = "#af8700"
}

color.blue = {
   term = 33,
   gui = "#0087ff"
}

color.purple = {
   term = 56,
   gui = "#5f00d7"
}

color.cyan = {
   term = 37,
   gui = "#00afaf"
}

color.green = {
   term = 64,
   gui = "#5f8700"
}

color.orange = {
   term = 166,
   gui = "#d75f00"
}

color.red = {
   term = 160,
   gui = "#d70000"
}

color.yellow = {
   term = 142,
   gui = "#afaf00"
}

color.violet = {
   term = 61,
   gui = "#5f5faf"
}

-- color.violet = {
--    term = 62,
--    gui = "#5f5fd7"
-- }


local function hl(group, fg, bg, extra)
   local opts = {}

   if(fg and fg.link) then
      opts.link = fg.link
   else
      if(fg ~= nil) then
         if(fg.gui) then
            opts.fg = fg.gui
         end

         if(fg.term) then
            opts.ctermfg = fg.term
         end

         if(fg.default) then
            opts.default = true
         end

         opts.bold = opts.bold or fg.bold
         opts.italic = opts.italic or fg.italic
      end

      if(bg ~= nil) then
         if(bg.gui) then
            opts.bg = bg.gui
         end

         if(bg.term) then
            opts.ctermbg = bg.term
         end

         opts.bold = opts.bold or bg.bold
         opts.italic = opts.italic or bg.italic
      end

      if(extra ~= nil) then
         opts.bold = opts.bold or extra.bold
         opts.italic = opts.italic or extra.italic
      end
   end

   -- local style = color.style and "gui=" .. color.style or "gui=NONE"
   -- local fg = color.gui and "guifg=" .. fg.gui or "guifg=NONE"
   -- local bg = color.bg and "guibg=" .. color.bg or "guibg=NONE"

   vim.api.nvim_set_hl(0, group, opts)
end

hl("Normal", color.fg)

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

-- local highlight = {
--     "RainbowRed",
--     "RainbowYellow",
--     "RainbowBlue",
--     "RainbowOrange",
--     "RainbowGreen",
--     "RainbowViolet",
--     "RainbowCyan",
-- }

-- vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
-- vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
-- vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
-- vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
-- vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
-- vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
-- vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })
-- vim.api.nvim_set_hl(0, "RainbowOrange", { ctermfg = color.orange.term })
vim.api.nvim_set_hl(0, "Background", { ctermfg = 0 })
vim.api.nvim_set_hl(0, "LightGray", { ctermfg = 240 })

local highlight = {
    "RainbowRed",
    "RainbowYellow",
    "RainbowBlue",
    "RainbowOrange",
    "RainbowGreen",
    "RainbowViolet",
    "RainbowCyan",
}

-- local hooks = require "ibl.hooks"
-- create the highlight groups in the highlight setup hook, so they are reset
-- every time the colorscheme changes
-- hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
    vim.api.nvim_set_hl(0, "RainbowRed", { ctermfg = color.red.term, fg = "#E06C75" })
    vim.api.nvim_set_hl(0, "RainbowYellow", { ctermfg = color.purple.term,  fg = "#E5C07B" })
    vim.api.nvim_set_hl(0, "RainbowBlue", { ctermfg = color.blue.term, fg = "#61AFEF" })
    vim.api.nvim_set_hl(0, "RainbowOrange", { ctermfg = color.orange.term, fg = "#D19A66" })
    vim.api.nvim_set_hl(0, "RainbowGreen", { ctermfg = color.green.term, fg = "#98C379" })
    vim.api.nvim_set_hl(0, "RainbowViolet", { ctermfg = color.violet.term, fg = "#C678DD" })
    vim.api.nvim_set_hl(0, "RainbowCyan", { ctermfg = color.cyan.term, fg = "#56B6C2" })
-- end)

require("ibl").setup {
   debounce = -1,
   indent = {
      highlight = highlight
   },
   scope = {
      enabled = true,
      show_start = false,
      -- highlight = { "RainbowOrange" }
      highlight = { "LightGray", "RainbowOrange" }
      -- highlight = highlight
   },
}

-- require("ibl").setup({
--    scope = { 
--       enabled = true,
--       show_start = false,
--       -- highlight = { "RainbowOrange" }
--       -- highlight = { "LightGray" }
--       highlight = highlight
--    },
--    indent = {
--       char = "┆",
--       -- char = "▏",
--       -- char = "▎",
--       -- char = "▍",
--       -- char = "▌",
--       -- char = "▋",
--       -- char = "▊",
--       -- char = "▉",
--       -- char = "█",
--       -- char = "│",
--       -- char = "┃",
--       -- char = "╎",
--       -- char = "╏",
--       -- char = "┇",
--       -- char = "┊",
--       -- char = "┋",
--       -- char = "║",
--       -- char = "▕",
--       -- char = "▐",
--       -- highlight = { "Background", "Normal" }
--       -- highlight = { "Background", "RainbowOrange" }
--       highlight = { "Background" },
--       -- highlight = highlight 
--    },
--    whitespace = {
--       -- highlight = highlight,
--       remove_blankline_trail = false,
--    },
-- })

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


-- local links = {
--   ['@lsp.type.namespace'] = '@namespace',
--   ['@lsp.type.type'] = '@type',
--   ['@lsp.type.class'] = '@type',
--   ['@lsp.type.enum'] = '@type',
--   ['@lsp.type.interface'] = '@type',
--   ['@lsp.type.struct'] = '@structure',
--   ['@lsp.type.parameter'] = '@parameter',
--   ['@lsp.type.variable'] = '@variable',
--   ['@lsp.type.property'] = '@property',
--   ['@lsp.type.enumMember'] = '@constant',
--   ['@lsp.type.function'] = '@function',
--   ['@lsp.type.method'] = '@method',
--   ['@lsp.type.macro'] = '@macro',
--   ['@lsp.type.decorator'] = '@function',
-- }

-- for newgroup, oldgroup in pairs(links) do
--   vim.api.nvim_set_hl(0, newgroup, { link = oldgroup, default = true })
-- end


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
-- vim.api.nvim_set_hl(0, 'MatchParen', { ctermfg=136, ctermbg = "none", bold = true })
-- hl('MatchParen', color.bg, color.red)
-- hl('MatchParen', nil, color.red)
-- hl('MatchParen', color.gold, { bold = true })
hl('MatchParen', { term = 39 }, { bold = true })
-- hl('MatchParen', color.yellow, { bold = true })

hl('CursorLine', nil, color.gray.ll)

-- vim.wo.cursorcolumn = true
-- vim.api.nvim_set_hl(0, "CursorColumn", { ctermbg="darkred", ctermfg="white" })

hl('Comment', color.gray.ml) -- is 241, maybe bump to 242 if it's too dark.
-- hl('Comment', { term = 242 })

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

hl("@property.javascript", link.norm)
-- hl("@property.javascript", { link = "Normal", ctermfg = 247, default = true })

hl("@property.javascript", {})
hl("@lsp.type.property.javascript", {})
-- hl('@lsp.type.property.javascript', { })
-- hl('@lsp.type.variable.javascript', { })

hl('Identifier', { link = 'Normal' })
hl('@operator', { link = "Normal" })

hl('Constant', color.gold)
hl('Statement', color.blue)

hl("@variable.builtin", color.blue, { bold = true })
hl("@constant.builtin", color.cyan, { bold = true })

-- hl('@keyword', color.fg, { italic = true })
hl('@keyword', color.blue, { bold = true })

hl('@boolean', color.cyan, { bold = true })

-- hl('@object', color.gray.ll)
-- hl('@array', color.gray.ll)

hl('@object', color.orange)
hl('@array', color.orange)

-- hl('@keyword', color.cyan)

-- hl('@keyword.prototype.javascript', color.gray.ml, { italic = true })
-- hl("@keyword.function.javascript", color.green, { italic = true })

hl('@keyword.prototype.javascript', color.gray.ml, {})
-- hl("@keyword.function.javascript", color.green, {})

hl("@keyword.await.javascript", color.orange, { bold = true })
hl("@keyword.return", color.orange, { bold = true })
hl("@return_statement", color.orange)

hl("@punctuation.bracket", {})
-- hl("@punctuation.bracket", color.green)
-- hl("@punctuation.delimiter", color.gray.ml)
-- hl("@punctuation.delimiter", { term = 241 })
hl("@punctuation.delimiter", { term = 240 })

hl("@template_string", color.purple)

-- hl("@lsp.type.class", color.gray.mh)
-- hl("@lsp.type.class", { link = "Normal" })
hl("@lsp.type.class", { })
-- hl("@function", color.blue)

hl("@lsp.type.function", { })
hl("@function.builtin", { })

-- hl("@punctuation.bracket", color.green, { default = true })
-- hl("@punctuation.delimiter", color.gray.ml)

-- hl("@punctuation.bracket", { term = 240 }, { default = true })
-- hl("@punctuation.delimiter", { term = 240 })

hl("@keyword.function.javascript", { bold = true })
hl("@function.body.javascript", {})
-- hl("@function.body", color.purple)
hl("@function_block", color.green)
hl("@function.parameters.object_destructure", color.purple)
hl("@function.parameters.array_destructure", color.purple)
-- hl("@functionf", color.purple)
hl("@if_block", color.violet)
hl("@conditional", color.violet, { bold = true })
-- hl("@conditional", {})

-- hl("@function.call", color.blue)
-- hl("@method.call", color.blue)

-- hl("@call.arguments", color.blue)

-- hl("@call.arguments", color.gray.m)
hl("@call.arguments", { term = 245 })

hl("@property.javascript", { link = "Normal" })
hl("@variable.underscore", { term = 28 }, { bold = true })

-- hl("@function", color.purple)
-- hl("@function.call", color.blue)
