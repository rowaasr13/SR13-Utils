-- Modifies Auctionator sell buyout price when clicking on existing lot while holding alt:
-- Selects BID if it exists instead of buyout
-- Does NOT do any undercuts

local a_name, a_env = ...

local function AuctionatorSaleItemMixin_ReceiveEvent_PostHook(self, event, ...)
   if event ~= Auctionator.Selling.Events.PriceSelected then return end
   if not self.itemInfo then return end
   if not IsAltKeyDown() then return end

   local selectedPrices, shouldUndercut = ...
   local buyoutAmount = selectedPrices.bid or selectedPrices.buyout

   self:UpdateSalesPrice(buyoutAmount, nil, false)
end

local function HookPriceSelected()
   -- Possible to hook mixin directly, since Auctionator creates windows on-demand, NOT on start
   hooksecurefunc(AuctionatorSaleItemMixin, "ReceiveEvent", AuctionatorSaleItemMixin_ReceiveEvent_PostHook)
end

EventUtil.ContinueOnAddOnLoaded("Auctionator", HookPriceSelected)
