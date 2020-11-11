local function UpdateOverlayFrameText_details(self)
   local text = self.OverlayFrame.Text
   if not text:IsShown() then return end

   local bar = self.StatusBar
   local xp = bar:GetAnimatedValue();
   local _, totalLevelXP = bar:GetMinMaxValues();

   text:SetFormattedText("%s | Left: %d", text:GetText(), totalLevelXP - xp)
end

-- Won't work:
-- hooksecurefunc(AzeriteBarMixin, "UpdateOverlayFrameText", UpdateOverlayFrameText_details)
-- templates grabbed their own ref to function from Mixin already, so we'll hook bar addition and scan bars to find copies instead

local function hook_AzeriteBar()
   for idx, bar in pairs(StatusTrackingBarManager.bars) do
      -- print("BAR", bar.UpdateOverlayFrameText == AzeriteBarMixin.UpdateOverlayFrameText)
      if bar.UpdateOverlayFrameText == AzeriteBarMixin.UpdateOverlayFrameText then
         hooksecurefunc(bar, "UpdateOverlayFrameText", UpdateOverlayFrameText_details)
      end
   end
end

hooksecurefunc(StatusTrackingBarManager, "AddBarFromTemplate", hook_AzeriteBar)
