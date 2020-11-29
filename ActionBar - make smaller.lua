local a_name, a_env = ...

a_env.register_slash("ActionBarSmall", { "/absmall" }, function(arg)
   MainMenuBarArtFrame.LeftEndCap:Hide()
   MainMenuBarArtFrame.RightEndCap:Hide()
   local arg = tonumber(arg) or 0.8
   MainMenuBarArtFrame:SetScale(arg)

   -- indirectly trigger action bars update without tainting
   local sfx = GetCVar("Sound_EnableSFX")
   if sfx == "1" then SetCVar("Sound_EnableSFX", "0") end                    
   for idx = 1, 2 do
      InterfaceOptionsActionBarsPanelBottomLeft:Click()
   end
   if sfx == "1" then SetCVar("Sound_EnableSFX", "1") end
end)

_G.ABU = function()
   local event_handlers = { GetFramesRegisteredForEvent("ACTIONBAR_SLOT_CHANGED") }
   for idx = 1, #event_handlers do
      print(idx)
      local frame = event_handlers[idx]
      local script = frame:GetScript("OnEvent")
      if script then script(frame, "ACTIONBAR_SLOT_CHANGED") end
   end
end
