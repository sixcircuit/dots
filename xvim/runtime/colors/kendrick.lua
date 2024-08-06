
vim.opt.background = 'dark'

vim.cmd('highlight clear')
if vim.fn.exists('syntax_on') then
   vim.cmd('syntax reset')
end

vim.g.colors_name = 'kendrick'

local function disable_all_highlight_groups()
   -- Retrieve list of all highlight groups
   local highlight_groups = vim.api.nvim_get_hl(0, { link = true })

   -- Iterate and disable each group
   for group, info in pairs(highlight_groups) do
      if not info.link then
         -- vim.print(group)
         -- vim.print(info)
      end
      if not info.link then
         vim.api.nvim_set_hl(0, group, {})
      end
      -- vim.api.nvim_set_hl(0, group, {})
   end
end

-- disable_all_highlight_groups()


local link = {}

link.norm = { link = "Normal" }
link.todo = { link = "Todo" }
link.constant = { link = "Constant" }

local color = {}

color.gray = {
   llll = { term = 232, gui = "#080808" },
   lll = { term = 233, gui = "#121212" },
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

color.cursor = {
   term = 244,
   gui = "#808080"
}

color.fg = color.gray.mh

color.gold = {
   term = 136,
   gui = "#af8700",
   h = {
      term = 178,
      gui = "#d7af00"
   },
   hh = {
      term = 220,
      gui = "#ffd700"
   },
   -- l = { hideous. don't use it.
   --    term = 94,
   --    gui = "#875f00"
   -- }
}

color.blue = {
   term = 33,
   gui = "#0087ff",
   l = {
      term = 26,
      gui = "#005fd7"
   },
   -- h = {
   --    term = 27,
   --    gui = "#005fff"
   -- }
}

color.purple = {
   term = 56,
   gui = "#5f00d7"
}

color.cyan = {
   term = 37,
   gui = "#00afaf",
   l = {
      term = 30,
      gui = "#008787"
   },
   h = {
      term = 43,
      gui = "#00d7af"
   },
   hh = {
      term = 51,
      gui = "#00ffff"
   }
}
-- color.cyan = color.cyan.l
-- color.cyan.l = color.cyan

color.green = {
   term = 64,
   gui = "#5f8700",
   h = {
      term = 28,
      gui = "#00af00"
   },
   l = {
      term = 29,
      gui = "#00875f",
      -- term = 23,
      -- gui = "#005f5f
      -- term = 22,
      -- gui = "#005f00"
   }
   -- hh = {
   --    term = 34,
   --    gui = "#00af00"
   -- }
   -- hh = {
   --    term = 35,
   --    gui = "#00af5f"
   -- }
}

color.orange = {
   term = 166,
   gui = "#d75f00",
   l = {
      term = 130,
      gui = "#af5f00"
   }
}

color.red = {
   term = 124,
   gui = "#af0000",
   h = {
      term = 160,
      gui = "#d70000"
   },
   l = {
      term = 88,
      gui = "#870000"
   }
}

color.yellow = {
   term = 142,
   gui = "#afaf00",
   l = {
      term = 100,
      gui = "#878700"
   }
}

color.magenta = {
   term = 125,
   gui = "#af005f"
}

color.pink = {
   term = 126,
   gui = "#af0087"
}

color.violet = {
   term = 61,
   gui = "#5f5faf"
   -- term = 62,
   -- gui = "#5f5fd7"
}

local function _hl(opts, piece, key)
   if(key ~= nil) then
      if(piece.gui) then opts[key] = piece.gui end
      if(piece.term) then opts["cterm" .. key] = piece.term end
   end
   if(piece.default ~= nil) then opts.default = piece.default end
   if(piece.bold ~= nil) then opts.bold = piece.bold end
   if(piece.italic ~= nil) then opts.italic = piece.italic end
   if(piece.underline ~= nil) then opts.underline = piece.underline end
   if(piece.undercurl ~= nil) then opts.undercurl = piece.undercurl end
   if(piece.reverse ~= nil) then opts.reverse = piece.reverse end
   if(piece.standout ~= nil) then opts.standout = piece.standout end
   -- expect piece.sp to be a color with a gui attribute
   if(piece.sp ~= nil and piece.sp.gui ~= nil) then
      opts.sp = piece.sp.gui
   end
end

local function hl(group, fg, bg, extra)
   local opts = {}

   if(fg and fg.link) then
      opts.link = fg.link
   else
      if(fg ~= nil) then _hl(opts, fg, "fg") end
      if(bg ~= nil) then _hl(opts, bg, "bg") end
      if(extra ~= nil) then _hl(opts, extra) end
   end

   vim.api.nvim_set_hl(0, group, opts)
end


vim.api.nvim_create_autocmd("TextYankPost", {
    group = vim.api.nvim_create_augroup("highlight_yank", { clear = true }),
    pattern = "*",
    callback = function()
        vim.highlight.on_yank({ higroup = "HighlightYank", timeout = 200 })
        -- vim.highlight.on_yank({ higroup = "IncSearch", timeout = 200 })
        -- vim.highlight.on_yank({ higroup = "Search", timeout = 200 })
    end,
})

-- set fill char to non-breaking space (it's there between the ' '', it's not a normal space)
-- since we set the statusbar colors the same below it'll add ^^^ to the status line because it doesn't know anything about lightline
vim.opt.fillchars = { stl = ' ' }

-- menu highlights

local ui = {}

ui.dark = {
   term = 234,
   gui = "#1c1c1c"
}

ui.light = color.fg

hl("FloatBorder", ui.light, ui.dark)
hl("FloatTitle", ui.light, ui.dark)
hl("Pmenu", ui.light, ui.dark)
hl("PmenuSel", ui.dark, ui.light)
hl("PmenuSbar", ui.dark, ui.light)
hl("PmenuThumb", ui.dark, ui.light)
hl("NormalFloat", { link = "PMenu" })

-- completion item in completion menu
hl("CmpItemKind", { link = "Pmenu" })
-- hl("CmpItemKindFunction", color.green)
-- hl("CmpItemKindMethod", color.green)

hl("VertSplit", ui.dark, ui.dark)
hl("WinSeparator", { link = "VertSplit" })
hl("StatusLine", ui.dark, ui.dark)
hl("StatusLineNC", ui.dark, ui.dark)


-- line numbers and tab lines
-- hl("TabLine", ui.light, ui.dark, { underline = false })
-- hl("TabLineFill", ui.dark, { underline = true })
-- hl("TabLineSel", ui.dark, color.magenta, { underline = false })

hl("TabLine", color.gray.m, { underline = true })
hl("TabLineFill", color.gray.m, { underline = true })
hl("TabLineSel", color.gray.hh, color.gray.l, { underline = true })

-- hl("TabLine", color.bg, color.green, { underline = false })
-- hl("TabLineFill", color.green, color.green, { underline = false })
-- hl("TabLineSel", color.bg, color.magenta, { underline = false })

hl("LineNr", color.gray.l)
hl("EndOfBuffer", color.gray.l)
-- hl("EndOfBuffer", color.gray.ll, color.gray.llll)
hl("CursorLine", nil, color.gray.ll)
hl("CursorLineNR", color.gray.ml, color.gray.ll)

-- vim.wo.cursorcolumn = true
-- hl("CursorColumn", { ctermbg="darkred", ctermfg="white" })

hl("Cursor", color.bg, color.fg)
hl("lCursor", { link = "Cursor" })

hl("QuickFixLine", { link = "Search" })

hl("DiffAdd", color.green)
hl("DiffChange", color.gold)
hl("DiffDelete", color.red)
-- hl("DiffText", color.blue)
hl("DiffText", color.cyan)


-- TODO: setup undercurl
hl("SpellBad", { undercurl = true, sp = color.red })
hl("SpellCap", { undercurl = true, sp = color.violet })
hl("SpellRare", { undercurl = true, sp = color.cyan })
hl("SpellLocal", { undercurl = true, sp = color.gold })

-- don't know about these

hl("VisualNOS", color.fg)
hl("WarningMsg", color.red, { bold = true })
hl("WildMenu", color.fg)
hl("Folded", color.fg, { underline = true, bold = true })
hl("FoldColumn", color.fg)

hl("Conceal", color.blue)

-- diagnostic signs

local sign_col_bg = color.bg
-- local sign_col_bg = color.gray.lll

vim.opt.signcolumn = "yes"
hl("SignColumn", {})

hl("SignColumn", nil, sign_col_bg)
hl("DiagnosticError", color.red, sign_col_bg)
hl("DiagnosticWarn", color.gold, sign_col_bg)
hl("DiagnosticInfo", color.gold, sign_col_bg)
hl("DiagnosticHint", color.gold, sign_col_bg)

vim.fn.sign_define("DiagnosticSignError", { text = "E", texthl = "DiagnosticSignError" })
vim.fn.sign_define("DiagnosticSignWarn",  { text = "W", texthl = "DiagnosticSignWarn" })
vim.fn.sign_define("DiagnosticSignInfo",  { text = "I", texthl = "DiagnosticSignInfo" })
vim.fn.sign_define("DiagnosticSignHint",  { text = "H", texthl = "DiagnosticSignHint" })

-- hop highlights

hl("HopNextKey", color.gold.h, { bold = true })
hl("HopNextKey1", color.gold.h, { bold = true })
hl("HopNextKey2", color.red, { bold = true })
hl("HopUnmatched", color.gray.l) -- 242
hl("HopCursor", { link = "Cursor" })
hl("HopPreview", { link = "IncSearch" })


-- scope highlighting

hl("ScopeHighlight_Default", color.gray.l)
hl("ScopeHighlight_Selected", color.gray.ml)
hl("IblWhitespace", color.bg)

require("ibl").setup({
   debounce = -1,
   exclude = {
      filetypes = { "text" }
   },
   scope = {
      enabled = true,
      show_start = false,
      highlight = { "ScopeHighlight_Selected" },
   },
   indent = {
      highlight = { "ScopeHighlight_Default" },
      char = "┆",
      -- char = "▏",
      -- char = "▎",
      -- char = "▍",
   },
})

-- code highlighting

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

-- this is for trailing space and tabs. basically all listchars.
hl("NonText", color.red)
hl("SpecialKey", color.red)
hl("Whitespace", color.red)

hl("Normal", color.fg)
hl("Comment", color.gray.ml) -- is 241, maybe bump to 242 if it's too dark.
-- hl('Comment', { term = 242 })
hl("Identifier", link.norm)
hl("PreProc", color.orange)
hl("Type", color.gold, { bold = true })

hl("Constant", color.gold)
hl("Statement", color.blue)
hl("Special", color.red)

hl("Underlined", color.violet)
hl("Ignore", color.fg, color.bg)
hl("Error", color.red, { bold = true })

hl("MoreMsg", color.blue)
hl("ModeMsg", color.blue)
hl("Question", color.cyan, { bold = true })
hl("Title", color.orange, { bold = true })
hl("VisualNOS", color.orange, { bold = true })

local vis_color = color.gold
-- local vis_color = color.orange.l

-- hl("Visual", color.bg, vis_color)
-- hl("Visual", color.bg, color.violet)
hl("Visual", color.bg, color.gray.ml)
hl("HighlightYank", color.bg, vis_color)
hl("Search", color.bg, vis_color)
hl("CurSearch", color.bg, vis_color.hh)
hl("IncSearch", color.bg, vis_color)

-- hl("MatchParen", color.gold, { bold = true })
-- hl("MatchParen", color.gray.hh, { bold = true })
hl("MatchParen", color.cyan.h, { bold = true })

hl("Todo", color.magenta, { bold = true })

hl("Directory", color.gold, { bold = true })
hl("ErrorMsg", color.bg, color.red)


hl("@keyword.this", color.blue, { bold = true })
hl("@variable.self", color.blue, { bold = true })
hl("@exception", color.blue, { bold = true })

hl("@variable.declaration.self.this", color.blue, { bold = false, italic = false })
hl("@variable.declaration.self.error", color.magenta, { bold = false, italic = false })

hl("@variable.underscore", color.gray.m, { bold = true })

hl("@constant.builtin", color.cyan, { bold = true })

hl("@type", color.fg, { bold = false })
hl("@type.builtin", color.gray.ml, { bold = false })
hl("@variable.builtin", color.fg, { bold = false })
hl("@constant", color.fg, { bold = false })

-- hl("@keyword", color.fg, { italic = true })
hl('@keyword', color.blue, { bold = true })

hl('@boolean', color.cyan, { bold = true })


-- hl("@keyword", color.cyan)

hl("@keyword.prototype.javascript", color.gray.ml, { bold = false })

hl("@keyword.coroutine", {})
hl("@keyword.async", color.green, { bold = true })
hl("@keyword.await", color.orange.l, { bold = true })
hl("@keyword.return", color.orange.l, { bold = true })
hl("@return.block", color.orange.l)

hl("@punctuation.bracket", {})
hl("@punctuation.delimiter", { term = 240, gui = "#585858" })

hl("@parenthesis.block", color.gray.m, { default = true })

hl("@string.template", color.gold)
hl("@string.template.substitution", color.red.l)

hl("@constructor", { })
hl("@lsp.type.class", { })

-- TODO: improve these classes below. could be great.
-- local class_color = color.cyan.m
-- local class_fg = { bold = false, italic = false }
-- hl("@lsp.type.class", class_color, class_fg)
-- hl("@constructor", class_color, class_fg)
-- hl("@method", color.gray.mh, { bold = true })
-- hl("@method", { bold = true })

-- hl("@method.call", { bold = true })
-- hl("@function.call", { bold = true })

hl("@lsp.type.comment", { })
hl("@lsp.type.function", { })
hl("@function.builtin", { })

hl("String", link.constant)
hl("Function", link.norm)
hl("@variable", link.norm)
hl("@parameter.javascript", link.norm)
hl("@string.regex", link.constant)
hl("@preproc.javascript", { link = "PreProc" })

-- hl("@punctuation.bracket", color.green, { default = true })
-- hl("@punctuation.delimiter", color.gray.ml)

-- hl("@punctuation.bracket", { term = 240 }, { default = true })
-- hl("@punctuation.delimiter", { term = 240 })

hl("@keyword.function", { bold = true })
hl("@function.body", {})
hl("@function.block", color.green)

-- local loop_color = color.violet
-- local loop_color = color.green.l
-- local loop_color = color.cyan.l
local loop_color = color.yellow.l

hl("@repeat", loop_color, { bold = true })
hl("@loop.block", loop_color)
hl("@loop.condition", loop_color)

hl("@conditional", color.violet, { bold = true })

hl("@if.block", color.violet)
hl("@if.condition", color.violet)
hl("@lsp.type.property", {})
hl("@property", color.fg, { default = true })
hl("@label.json", color.fg, { default = true })

-- hl("@operator", {})
hl("@operator", link.norm)
-- hl("@operator", color.fg, { bold = true })

hl("@lsp.type.variable", {})
-- hl("@variable", {})
-- hl("@variable", color.gray.mh, { italic = true })

hl("@lsp.type.parameter", {})
-- hl("@parameter", {})
-- hl("@parameter", color.gray.mh, { italic = true })

-- hl("@lsp.type.parameter", color.fg, { bold = false })
-- hl("@lsp.typemod.variable.declaration", { italic = true })
hl("@lsp.type.namespace.javascript", {});

hl("@object", color.gray.m)
hl("@array", color.gray.m)

hl("@punctuation.subscript", color.gray.m)

hl("@object.destructure", color.blue, { italic = false })
hl("@array.destructure", color.blue, { italic = false })



-- hl("@function.call", color.blue)
-- hl("@method.call", color.blue)

-- hl("@call.arguments", color.blue)

hl("@call.arguments", color.gray.m)

hl("@arguments.rest_pattern", color.red.l)
hl("@operator.spread_element", color.red.l)

hl("@tag.html", link.norm)
hl("@tag.delimiter", color.gray.ml)

hl("@text.todo", link.todo)
hl("@text.note", link.todo)
hl("@text.warning", link.todo)
hl("@text.danger", link.todo)
-- hl("@text.uri", link.todo)

