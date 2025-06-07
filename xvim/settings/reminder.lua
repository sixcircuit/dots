
local min_to_ms = function (min)
   return (min * (60 * 1000))
end

local function shallow_copy(orig)
   local copy = {}
   for k, v in pairs(orig) do
      copy[k] = v
   end
   return copy
end

local timer = nil
local show_popup

local function pad_c(str, width)
   local len = #str
   if len >= width then
      return str
   end

   local total_pad = width - len
   local left_pad = math.ceil(total_pad / 2)
   local right_pad = total_pad - left_pad

   return string.rep(" ", left_pad) .. str .. string.rep(" ", right_pad)
end

local function start_popup_timer(delay_ms, message, autoclose_ms)
   if timer then
      timer:stop()
      timer:close()
   end

   timer = vim.loop.new_timer()
   timer:start(delay_ms, 0, vim.schedule_wrap(function()
      show_popup(message, autoclose_ms, function()
         start_popup_timer(delay_ms, message, autoclose_ms)
      end)
   end))
end

local function center_message(message, extra_line)
   local copy = {}
   local max_len = 0

   if extra_line then max_len = #extra_line end

   for k, line in pairs(message) do
      max_len = math.max(max_len, #line)
      -- print("cur: ".. tostring(#line) .. " max: " .. tostring(max_len) .. " : " .. line)
      copy[k] = line
   end

   if extra_line then
      table.insert(copy, #copy + 1, "")
      table.insert(copy, #copy + 1, extra_line)
   end

   max_len = max_len + 4

   for k, line in pairs(copy) do
      copy[k] = pad_c(line, max_len + 1)
   end

   -- print("max_len: ", tostring(max_len))

   table.insert(copy, 1, "")
   table.insert(copy, 1, string.rep("❤️ ", (max_len / 2) + 1))
   table.insert(copy, #copy + 1, "")
   table.insert(copy, #copy + 1, string.rep("❤️ ", (max_len / 2) + 1))

   return max_len + 1, copy
end

show_popup = function(message, autoclose_ms, on_close)
   local buf = vim.api.nvim_create_buf(false, true)

   local width
   local formatted
   if not autoclose_ms then
      width, formatted = center_message(message, 'press "q" to dismiss.')
   else
      width, formatted = center_message(message)
   end

   vim.api.nvim_buf_set_lines(buf, 0, -1, false, formatted)

   local height = #formatted
   local opts = {
      style = "minimal",
      relative = "editor",
      row = math.floor((vim.o.lines - height) / 2),
      col = math.floor((vim.o.columns - width) / 2),
      width = width,
      height = height,
      border = "rounded",
   }

   local win_id = vim.api.nvim_open_win(buf, true, opts)

   if autoclose_ms then
      vim.defer_fn(function()
         if vim.api.nvim_win_is_valid(win_id) then
            vim.api.nvim_win_close(win_id, true)
         end
         if on_close then on_close() end
      end, autoclose_ms)
   else
      vim.keymap.set("n", "q", function()
         if win_id and vim.api.nvim_win_is_valid(win_id) then
            vim.api.nvim_win_close(win_id, true)
            if on_close then on_close() end
         end
      end, { buffer = buf, nowait = true })
   end

end


start_popup_timer(min_to_ms(30), {
   "i love you.",
   "try to relax your whole body.",
   "your shoulders.",
   "your arms.",
   "your back.",
   "your hands.",
   "like noodles",
})

vim.api.nvim_create_user_command("W", function()

   local message = {
      "i love you.",
      "stop typing :w",
      "just stop for a sec",
      "relax your hands",
   }

   show_popup(message, 2500, function ()
      vim.cmd("write")
   end)

end, {})

vim.cmd([[
  cmap w W
]])

