local a_name, a_env = ...

a_env.register_slash("ActionBarSmall", { "/absmall" }, function(arg)
   MainMenuBarArtFrame.LeftEndCap:Hide()
   MainMenuBarArtFrame.RightEndCap:Hide()
   local arg = tonumber(arg) or 0.8
   MainMenuBarArtFrame:SetScale(arg)
   ActionBarController_UpdateAll(true)
   MultiActionBar_Update()
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
