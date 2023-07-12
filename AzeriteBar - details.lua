local a_name, a_env = ...

local function UpdateOverlayFrameText_details(self)
   local text = self.OverlayFrame.Text
   if not text:IsShown() then return end

   local bar = self.StatusBar
   local xp = bar:GetAnimatedValue();
   local _, totalLevelXP = bar:GetMinMaxValues()

   text:SetFormattedText("%s | Left: %d", text:GetText(), totalLevelXP - xp)
end

local function HookAzeriteBar(self)
   local bars = self.bars
   for idx = 1, #bars do
      local frame = bars[idx]
      if frame.UpdateOverlayFrameText == AzeriteBarMixin.UpdateOverlayFrameText then
         hooksecurefunc(frame, "UpdateOverlayFrameText", UpdateOverlayFrameText_details)
         frame:UpdateTextVisibility()
         frame:Update()
      end
   end
end

HookAzeriteBar(MainStatusTrackingBarContainer)
HookAzeriteBar(SecondaryStatusTrackingBarContainer)
