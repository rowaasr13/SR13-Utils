local a_name, a_env = ...

local function ToggleCVarOutline()
   local cvar_name = "Outline"
   local prev = GetCVar(cvar_name)
   local new = (prev == "0") and "1" or "0"
   print("Setting " .. cvar_name .. ": " .. prev .. " => " .. new .. ".")
   SetCVar(cvar_name, new)
end

local button = CreateFrame("Button", a_name .. "Button.ToggleCVarOutline")
button:SetScript("OnClick", ToggleCVarOutline)
SetOverrideBindingClick(button, false, "CTRL-O", button:GetName())
