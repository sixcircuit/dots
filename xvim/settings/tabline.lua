-- based on
-- https://github.com/mkitt/tabline.vim

local function filename_buffers(type)
   local bufs;

   if type == "tabs" then
      bufs = {}
      local seen = {}

      local tab_count = vim.fn.tabpagenr('$')

      for i = 1, tab_count do
         local winnr = vim.fn.tabpagewinnr(i)
         local buflist = vim.fn.tabpagebuflist(i)
         for _, bufnr in ipairs(buflist) do
            if not seen[bufnr] then
               seen[bufnr] = true
               table.insert(bufs, bufnr)
            end
         end
      end
   else
      bufs = vim.api.nvim_list_bufs()
   end

   local paths = {}

   -- Collect all full paths
   for _, bufnr in ipairs(bufs) do
      if vim.api.nvim_buf_is_loaded(bufnr) and vim.bo[bufnr].buflisted then
         local name = vim.fn.bufname(bufnr)
         if name ~= '' then
            local path = vim.fn.fnamemodify(name, ':p')  -- absolute path
            path = vim.fn.fnamemodify(path, ":~")
            path = vim.fn.fnamemodify(path, ":.")
            paths[bufnr] = path
         end
      end
   end

   -- Build a reverse map from filenames to all buffers that use them
   local filename_to_buffers = {}
   for bufnr, fullpath in pairs(paths) do
      local filename = vim.fn.fnamemodify(fullpath, ':t')
      filename_to_buffers[filename] = filename_to_buffers[filename] or {}
      table.insert(filename_to_buffers[filename], { bufnr = bufnr, path = fullpath })
   end

   return filename_to_buffers
end

-- from chatgpt, it seems ok but it doesn't matter a ton. it's just for display.
-- if it's broken, i'll fix it later

local function compute_shortest_names(type)
   local buffers = filename_buffers(type)

   local results = {}

   for filename, fname_buffers in pairs(buffers) do
      if #fname_buffers == 1 then
         -- only one buffer, so it's unique
         results[fname_buffers[1].bufnr] = filename
      else
         -- multiple buffers, need to differentiate

         local split_paths = {}
         local max_parts = 0
         for _, info in ipairs(fname_buffers) do
            local parts = vim.split(info.path, '/')
            table.insert(split_paths, parts)
            max_parts = math.max(max_parts, #parts)
         end

         -- Compare backwards from filename until uniqueness
         for depth = 1, max_parts do
            local seen = {}
            local unique = true

            for i, parts in ipairs(split_paths) do
               local suffix = table.concat(vim.list_slice(parts, #parts - depth + 1), '/')
               if seen[suffix] then
                  unique = false
                  break
               end
               seen[suffix] = true
            end

            if unique then
               -- Use this depth for all
               for i, info in ipairs(fname_buffers) do
                  local parts = split_paths[i]
                  local suffix = table.concat(vim.list_slice(parts, #parts - depth + 1), '/')
                  results[info.bufnr] = suffix
               end
               break
            end
         end
      end
   end

   return results
end

local function tab_label(i, bufnr, unique_paths)
   local bufname = vim.fn.bufname(bufnr)
   local is_modified = vim.fn.getbufvar(bufnr, "&mod") == 1
   local name

   if bufname == "" then
      name = '*'
   else
      name = unique_paths[bufnr]
   end

   -- for command windows that just pop up like command-t
   if name == "" or name == nil then
      name = bufname
   end

   local label = '[' .. name .. ']'

   if is_modified then
      -- name = name .. '%#TabLineModifiedIcon#•'
      -- name = name .. ' •'
      -- name = name .. '*'
      label = label .. '[+]'
   end


   return label
end

function _G.TablineSimple()

   local tab_count = vim.fn.tabpagenr('$')
   local unique_paths = compute_shortest_names("tabs")

   local labels = {}

   for i = 1, tab_count do
      local winnr = vim.fn.tabpagewinnr(i)
      local buflist = vim.fn.tabpagebuflist(i)
      local bufnr = buflist[winnr]

      local label = tab_label(i, bufnr, unique_paths)
      local len = vim.fn.strdisplaywidth(label) + 1 -- add 1 for the extra space.
      local style = "TabLine"

      if (i == vim.fn.tabpagenr()) then
         style = "TabLineSel"
      end

      local style_f = function(s)
         local leading_space = true
         -- add the %iT for mouse clicks (say the docs) (the docs are correct)
         s = '%#' .. style .. '#' .. '%' .. i .. 'T' .. s .. '%*'
         if leading_space then
            s = ' ' .. s
         end
         return s
      end

      table.insert(labels, { label = label, len = len, style_f = style_f })

   end

   local s = ''
   local total_len = 0
   local cols = vim.o.columns
   local used = 0
   local tab_count_label
   local needs_tab_count_label = false

   local function tab_count_label_f(n)
      return "[+" .. (tab_count - (used + n)) .. "]"
   end

   local function trunc_label(item, cols_left)
      local extra = "..]"
      local label = item.label:sub(1, ((cols_left - 1) - #extra))
      label = label .. extra
      return label
   end

   local function add_padding(cols_left)
      local label = ""
      -- if cols_left == 0 then
      --    label = ""
      -- elseif cols_left == 1 then
      --    label = "|"
      -- elseif cols_left == 2 then
      --    label = "||"
      -- elseif cols_left == 3 then
      --    label = "|||"
      -- elseif cols_left == 4 then
      --    label = "||||"
      -- else
         label = string.rep(" ", cols_left)
      -- end
      s = label .. s
   end

   local function add_label(item, label)
      used = used + 1
      total_len = total_len + (#label + 1) -- add one for extra space
      s = item.style_f(label) .. s
   end

   local function cols_left(n)
      return ((cols - n) - total_len)
   end

   for i = #labels, 1, -1 do
      local item = labels[i]

      tab_count_label = tab_count_label_f(1)

      local cols_l = cols_left(#tab_count_label)

      if (item.len > cols_l) then

         if i == 1 then -- last item

            if (item.len < cols_left(0)) then -- does it fit without a tab count?
               add_label(item, item.label)
            else
               if cols_l < 5 then
                  needs_tab_count_label = true
                  tab_count_label = tab_count_label_f(0)
                  add_padding(cols_l)
               else
                  add_label(item, trunc_label(item, cols_left(0)))
               end
            end
         else
            needs_tab_count_label = true
            if cols_l < 5 then
               tab_count_label = tab_count_label_f(0)
               add_padding(cols_l)
            else
               add_label(item, trunc_label(item, cols_l))
            end
         end

         break
      else
         add_label(item, item.label)
      end
   end

   if needs_tab_count_label then
      local style
      if (vim.fn.tabpagenr() <= (tab_count - used)) then
         style = "TabLineSel"
      else
         style = "TabLine"
      end
      s = "%#".. style .. "#" .. tab_count_label .. '%*' .. s
   end

   s = s .. '%*%#TabLineFill#'

   return s
end

-- Superscript and subscript digit maps
local superscript = {
  ["0"] = "⁰", ["1"] = "¹", ["2"] = "²", ["3"] = "³", ["4"] = "⁴",
  ["5"] = "⁵", ["6"] = "⁶", ["7"] = "⁷", ["8"] = "⁸", ["9"] = "⁹",
  ["/"] = "⁄", ["-"] = "⁻"
}

local subscript = {
  ["0"] = "₀", ["1"] = "₁", ["2"] = "₂", ["3"] = "₃", ["4"] = "₄",
  ["5"] = "₅", ["6"] = "₆", ["7"] = "₇", ["8"] = "₈", ["9"] = "₉",
  ["/"] = "/",  ["-"] = "₋" -- no subscript slash, fallback to normal
}

-- Helper to convert a string to superscript or subscript
local function to_super(s)
  return (s:gsub(".", superscript))
end

local function to_sub(s)
  return (s:gsub(".", subscript))
end

--- Returns a unicode-styled fraction using superscript + subscript
--- @param num string|number: numerator
--- @param den string|number: denominator
--- @return string
function UnicodeFraction(num, den)
  num = tostring(num)
  den = tostring(den)
  return to_super(num) .. "⁄" .. to_sub(den)
end

function _G.Tabline()

   local tab_count = vim.fn.tabpagenr('$')
   local selected_tab_i = vim.fn.tabpagenr()

   local unique_paths = compute_shortest_names("tabs")

   local labels = {}

   for i = 1, tab_count do
      local winnr = vim.fn.tabpagewinnr(i)
      local buflist = vim.fn.tabpagebuflist(i)
      local bufnr = buflist[winnr]

      local label = tab_label(i, bufnr, unique_paths)
      local len = vim.fn.strdisplaywidth(label) + 1 -- add 1 for the extra space.
      local style = "TabLine"

      if (i == vim.fn.tabpagenr()) then
         style = "TabLineSel"
      end

      label = ' ' .. '%#' .. style .. '#' .. '%' .. i .. 'T' .. label .. '%*'

      table.insert(labels, { label = label, len = len })

   end

   local pages = {}

   local function new_page()
      local page = { i = (#pages + 1), tabline = "", cols_used = 0 }

      page.account = function(self, item)
         local len = #item.label
         if item.len then
            len = item.len
         end
         self.cols_used = self.cols_used + len
      end

      page.prepend = function(self, item)
         self:account(item)
         self.tabline = item.label .. self.tabline
      end

      page.append = function(self, item)
         self:account(item)
         self.tabline = self.tabline .. item.label
      end

      page.cols_left = function(self, n)
         return(vim.o.columns - (self.cols_used + n))
      end

      page.start_page = function(self, item)
         local label = item.label
         self:append({ label = '%#TabLineCornerLeft#', len = 0 })
         self:append({ label = label })
      end

      page.finish_page = function(self, item)
         local label = item.label
         self:append({ label = '%#TabLineFill#', len = 0 })
         self:append({ label = string.rep(" ", self:cols_left(#label)) })
         self:append({ label = '%#TabLineCornerRight#', len = 0 })
         self:append({ label = label })
      end

      table.insert(pages, page)

      return page
   end

   local function right_corner(i)
      return "[+" .. (tab_count - (i-1)) .. "]"
   end

   local function left_corner(i)
      return "[+" .. (i-1) .."]"
   end

   local cur_page = new_page()
   local selected_page

   cur_page:start_page({ label = "[|]" })

   for i = 1, #labels do
      local item = labels[i]

      local cols_l = cur_page:cols_left(#right_corner(i) + 1) -- ensure space

      if (item.len > cols_l) then
         cur_page:finish_page({ label = right_corner(i) })
         cur_page = new_page()
         cur_page:start_page({ label = left_corner(i) })
      end

      if (selected_tab_i == i) then
         selected_page = cur_page
      end

      cur_page:append(item)

   end

   cur_page:finish_page({ label = "[|]" })

   return selected_page.tabline
end

vim.o.showtabline = 2
vim.o.tabline = "%!v:lua.Tabline()"

