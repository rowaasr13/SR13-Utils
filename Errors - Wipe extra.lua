local a_name, a_env = ...

local tremove = table.remove
local function WipeExtraErrors()
   local f = ScriptErrorsFrame

   for idx = #f.messages, 1, -1 do
      local msg = f.messages[idx]
      if msg:find('SharedUIPanelTemplates') and (msg:find('cursorOffset') or msg:find('C stack')) then
         tremove(f.count, idx)
         tremove(f.messages, idx)
         tremove(f.times, idx)
         for stack, index in pairs(f.seen) do
            if index == idx then f.seen[stack] = nil break end
         end
         tremove(f.locals, idx)
         tremove(f.warnType, idx)
         tremove(f.order, idx)
      end
   end
end

a_env.register_slash("ShowErrors", { "/err" }, function(link)
   WipeExtraErrors()
   ScriptErrorsFrame:Show()
   ScriptErrorsFrame_Update()
end)