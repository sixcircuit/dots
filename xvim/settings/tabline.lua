-- based on
-- https://github.com/mkitt/tabline.vim
-- a long, long time ago. this is basically unrecognizable now

local _fill_char = "-"
local _show_tab_counts = false
local _first_page_fix = true
local _anchor = "[|]"

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

local function strlen(str)
   return vim.fn.strdisplaywidth(str)
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
      -- label = label .. '[+]'
   end


   return label
end

local function fill_chars(n, char)
   char = char or _fill_char
   -- char = "😊"
   local str = ""
   local w = vim.fn.strdisplaywidth(char)
   local total = 0
   while (total + w) < n do
      str = str .. char
      total = total + w
   end
   return(str)
end

local function utf8_sub_displaywidth(str, max_width)
  local result = ""
  local i = 1
  local width = 0

  while i <= #str do
    local char = vim.fn.strcharpart(str, i - 1, 1)
    local w = vim.fn.strdisplaywidth(char)

    if width + w > max_width then
      break
    end

    result = result .. char
    width = width + w
    i = i + vim.fn.strchars(char)
  end

  return result
end

local function new_base_page(pages)
   local page = { i = (#pages + 1), tabline = "", cols_used = 0 }

   page.account = function(self, item)
      local len = strlen(item.label)
      if item.len ~= nil then
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

   page.trunc_label = function(self, item, n)
      if n == nil then
         n = 0
      end
      local extra = "…]"
      -- local extra = "∙"
      -- local extra = "..]"
      local label = utf8_sub_displaywidth(item.raw, self:cols_left((strlen(extra) + n) + 1))
      label = label .. extra
      local len = (strlen(label) + 1) -- style_f adds leading space
      label = item.style_f(label)
      return({ label = label, len = len })
   end

   page.min_truc_len = 7 -- [xxx..]

   table.insert(pages, page)

   return page
end

local function compute_labels()

   local tab_count = vim.fn.tabpagenr('$')

   local unique_paths = compute_shortest_names("tabs")

   local labels = {}

   for i = 1, tab_count do
      local winnr = vim.fn.tabpagewinnr(i)
      local buflist = vim.fn.tabpagebuflist(i)
      local bufnr = buflist[winnr]

      local label = tab_label(i, bufnr, unique_paths)
      local is_modified = (vim.fn.getbufvar(bufnr, "&mod") == 1)
      local len = vim.fn.strdisplaywidth(label) + 1 -- add 1 for the extra space.
      local style = "TabLine"
      local selected = false

      if (i == vim.fn.tabpagenr()) then
         style = "TabLineSel"
         selected = true
      end

      if (is_modified) then
         style = style .. "Modified"
      end

      local raw = label

      local style_f = function(l)
         return(' ' .. '%#' .. style .. '#' .. '%' .. i .. 'T' .. l .. '%*')
      end

      label = style_f(label)

      table.insert(labels, { label = label, len = len, selected = selected, raw = raw, style_f = style_f })

   end

   return labels

end

function _G.TablineTruncatedStack()

   local labels = compute_labels()

   local pages = {}

   local function left_corner(i)
      if _show_tab_counts then
         return("[+" .. (i) .."]")
      else
         return("[+]")
      end
   end

   local function new_page()

      local page = new_base_page(pages)

      page.add_corner = function(self, i)
         local label = left_corner(i-1)
         local len = strlen(label)

         if (i > vim.fn.tabpagenr()) then
            label = "%#TabLineSel#" .. label .. '%*'
         end

         self:start_page({ label = label, len = len })
      end

      page.start_page = function(self, item)
         local label = item.label
         local len = strlen(label)
         if item.len ~= nil then
            len = item.len
         end
         self:prepend({ label = fill_chars(self:cols_left(len)) })
         self:prepend({ label = string.rep(" ", self:cols_left(len)) })
         self:prepend({ label = '%#TabLineFill#', len = 0 })
         self:prepend(item)
         self:prepend({ label = '%#TabLineCornerLeft#', len = 0 })
      end

      return page
   end

   local cur_page = new_page()

   for i = #labels, 1, -1 do
      local item = labels[i]

      local corner = left_corner(i)
      local cols_l = cur_page:cols_left(strlen(corner))

      if (item.len > cols_l) then

         if i == 1 then -- last item
            cols_l = cur_page:cols_left(0)
            if (item.len < cols_l) then -- does it fit without a tab count?
               cur_page:prepend(item)
            else
               if cols_l < cur_page.min_truc_len then
                  cur_page:add_corner(i+1)
               else
                  cur_page:prepend(cur_page:trunc_label(item, 0))
               end
            end
         else
            if cols_l < cur_page.min_truc_len then
               cur_page:add_corner(i+1)
            else
               cur_page:prepend(cur_page:trunc_label(item, strlen(corner)))
               cur_page:add_corner(i)
            end
         end

         break

      else
         cur_page:prepend(item)
      end
   end

   return cur_page.tabline

end


function _G.TablinePaged()

   local labels = compute_labels()
   local tab_count = #labels

   local pages = {}

   local function new_page()

      local page = new_base_page(pages)

      page.start_page = function(self, item)
         local label = item.label
         self:append({ label = '%#TabLineCornerLeft#', len = 0 })
         self:append({ label = label })
      end

      page.finish_page = function(self, item)
         local label = item.label
         self:append({ label = '%#TabLineFill#', len = 0 })

         if self:cols_left(strlen(label)) > 0 then
            self:append({ label = " " })
         end
         self:append({ label = fill_chars(self:cols_left(strlen(label))) })
         self:append({ label = string.rep(" ", self:cols_left(strlen(label))) })
         self:append({ label = '%#TabLineCornerRight#', len = 0 })
         self:append({ label = label })
      end

      page.right_corner = function(self, i)
         if _show_tab_counts then
            return "[+" .. (tab_count - (i-1)) .. "]"
         else
            return "[+]"
         end
      end

      page.left_corner = function(self, i)
         if _show_tab_counts then
            return "[+" .. (i-1) .."]"
         else
            return "[+]"
         end
      end

      table.insert(pages, page)

      return page

   end


   local cur_page = new_page()
   local selected_page

   cur_page:start_page({ label = _anchor })

   for i = 1, #labels do
      local item = labels[i]

      local cols_l = cur_page:cols_left(strlen(cur_page:right_corner(i)) + 1) -- ensure space

      if (item.len > cols_l) then
         cur_page:finish_page({ label = cur_page:right_corner(i) })
         cur_page = new_page()
         cur_page:start_page({ label = cur_page:left_corner(i) })
      end

      if (item.selected) then
         selected_page = cur_page
      end

      cur_page:append(item)

   end

   cur_page:finish_page({ label = _anchor })

   return selected_page.tabline
end


function _G.TablinePagedStack()

   local labels = compute_labels()
   local tab_count = #labels

   local pages = {}

   local function new_page()

      local page = new_base_page(pages)

      page.start_page = function(self, item, last_page)

         if _first_page_fix and last_page and #pages == 1 then

            local label = item.label

            self:prepend({ label = label })
            self:prepend({ label = '%#TabLineCornerLeft#', len = 0 })

            -- I fully admit this is horrifying.
            -- but it works so long as we don't change how the highlights work.
            -- we strip off the right corner, add all the extra fill stuff and then add the corner back

            local start_pos = self.tabline:find('%#TabLineCornerRight#')
            self.tabline = self.tabline:sub(1, start_pos-2)
            self.cols_used = self.cols_used - strlen(_anchor) - 1

            self:append({ label = '%#TabLineFill#', len = 0 })

            if self:cols_left(0) > 0 then
               self:append({ label = " " })
            end

            self:append({ label = fill_chars(self:cols_left(strlen(_anchor))) })
            self:append({ label = string.rep(" ", self:cols_left(strlen(_anchor))) })
            self:append({ label = '%#TabLineCornerRight#' .. _anchor, len = strlen(_anchor) })

         else
            local label = item.label
            self:prepend({ label = fill_chars(self:cols_left(strlen(label))) })
            self:prepend({ label = string.rep(" ", self:cols_left(strlen(label))) })
            self:prepend({ label = '%#TabLineFill#', len = 0 })
            self:prepend({ label = label })
            self:prepend({ label = '%#TabLineCornerLeft#', len = 0 })
         end
      end

      page.finish_page = function(self, item)
         local label = item.label
         self:prepend({ label = label })
         self:prepend({ label = '%#TabLineCornerRight#', len = 0 })
      end

      page.right_corner = function(self, i)
         if _show_tab_counts then
            return " [+" .. (tab_count - (i)) .. "]"
         else
            return " [+]"
         end
      end

      page.left_corner = function(self, i)
         if _show_tab_counts then
            return "[+" .. (i) .."]"
         else
            return "[+]"
         end
      end

      return page

   end

   local cur_page = new_page()
   local selected_page

   cur_page:finish_page({ label = " " .. _anchor })

   for i = #labels, 1, -1 do
      local item = labels[i]

      local cols_l = cur_page:cols_left(strlen(cur_page:left_corner(i)))

      if cols_l < cur_page.min_truc_len then

         cur_page:start_page({ label = cur_page:left_corner(i) })
         cur_page = new_page()
         cur_page:finish_page({ label = cur_page:right_corner(i) })

         cur_page:prepend(item)

      elseif (item.len > cols_l) then

         cur_page:prepend(cur_page:trunc_label(item, strlen(cur_page:left_corner(i))))

      else

         cur_page:prepend(item)

      end

      if (item.selected) then
         selected_page = cur_page
      end

   end

   cur_page:start_page({ label = _anchor }, true)

   return selected_page.tabline
end

vim.o.showtabline = 2
-- vim.o.tabline = "%!v:lua.TablineTruncatedStack()"
-- vim.o.tabline = "%!v:lua.TablinePaged()"
vim.o.tabline = "%!v:lua.TablinePagedStack()"

