local a_name, a_env = ...

local function UpdateOverlayFrameText_details(self)
   local text = self.OverlayFrame.Text
   if not text:IsShown() then return end

   local bar = self.StatusBar
   local xp = bar:GetAnimatedValue();
   local _, totalLevelXP = bar:GetMinMaxValues();

   text:SetFormattedText("%s | Left: %d", text:GetText(), totalLevelXP - xp)
end

local azerite_bar = a_env.FindFrameByPredicate(function(frame) return frame.UpdateOverlayFrameText == AzeriteBarMixin.UpdateOverlayFrameText end)
if azerite_bar then
   hooksecurefunc(azerite_bar, "UpdateOverlayFrameText", UpdateOverlayFrameText_details)
end
