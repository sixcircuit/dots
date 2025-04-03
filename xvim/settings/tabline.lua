-- based on
-- https://github.com/mkitt/tabline.vim

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

   -- local label = ' ' .. i .. ':' .. name .. ' '
   local label = '[' .. name .. ']'

   if is_modified then
      -- name = name .. '%#TabLineModifiedIcon#•'
      -- name = name .. ' •'
      -- name = name .. '*'
      label = label .. '[+]'
   end

   if is_modified then
      -- label = '%#TabLineModified#' .. label
   end

   return label
end

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


function _G.Tabline()
   local s = ''
   local tab_count = vim.fn.tabpagenr('$')
   local unique_paths = compute_shortest_names("tabs")

   for i = 1, tab_count do
      local winnr = vim.fn.tabpagewinnr(i)
      local buflist = vim.fn.tabpagebuflist(i)
      local bufnr = buflist[winnr]

      if (i == vim.fn.tabpagenr()) then
         s = s .. '%#TabLineSel#' .. ' ' .. tab_label(i, bufnr, unique_paths)
      else
         s = s .. ' %*' .. '%#TabLine#' ..  tab_label(i, bufnr, unique_paths) .. ''
      end

   end

   s = s .. ' %*%#TabLineFill#'

   return s
end

vim.o.showtabline = 2
vim.o.tabline = "%!v:lua.Tabline()"

