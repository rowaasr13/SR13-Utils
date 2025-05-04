local a_name, a_env = ...

local function RegisterToSellWithTC()
   local item_info =      AuctionatorSellingFrame
   item_info = item_info. SaleItemFrame
   item_info = item_info. itemInfo
   if not item_info then return end

   if item_info.itemID then
      print("TC autosell for session ", item_info.itemID,  item_info.itemLink)
      _G['SR13.exports'].TrashCompactor.autosell_reason[item_info.itemID] = 'set from Auctionator'
      _G['SR13.exports'].TrashCompactor.UpdateList()
   end
end
a_env.register_slash("tc_sell_10m", { "/tcsauc" }, RegisterToSellWithTC)
