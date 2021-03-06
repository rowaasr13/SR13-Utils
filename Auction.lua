local a_name, a_env = ...

-- AuctionHouseItemSellFrameMixin:OnSearchResultSelected
local function selectionCallback_undercut(searchResult)
   local self = AuctionHouseFrame.ItemSellFrame

   print("islselected", searchResult.buyoutAmount)
   print(self.PriceInput, self.PriceInput:GetAmount())

   self.PriceInput:SetAmount(self.PriceInput:GetAmount() - COPPER_PER_SILVER) 
end

local function UpdatePostState_kill_undercut_tip(self)
   self:HideHelpTip()
end

function auc_undercut()
   hooksecurefunc(AuctionHouseFrame.ItemSellList,  'selectionCallback', selectionCallback_undercut)
   hooksecurefunc(AuctionHouseFrame.ItemSellFrame, 'UpdatePostState',   UpdatePostState_kill_undercut_tip)
end
