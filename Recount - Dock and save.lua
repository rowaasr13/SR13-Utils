local a_name, a_env = ...

a_env.register_slash("RecountDock", { "/recountdock" }, function()
   Recount_MainWindow:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", 1, -1)
   Recount.SaveMainWindowPosition(Recount_MainWindow)
end)