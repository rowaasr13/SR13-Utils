local a_name, a_env = ...

local function GetAuctionatorItemInfo()
   local item_info =     AuctionatorSellingFrame
   item_info = item_info.SaleItemFrame
   item_info = item_info.itemInfo

   return item_info
end

local function RegisterToSellWithTC()
   local item_info = GetAuctionatorItemInfo()
   if not item_info then return end

   if item_info.itemID then
      print("TC autosell for session ", item_info.itemID,  item_info.itemLink)
      _G['SR13.exports'].TrashCompactor.autosell_reason[item_info.itemID] = 'set from Auctionator'
      _G['SR13.exports'].TrashCompactor.UpdateList()
   end
end
a_env.register_slash("tc_sell_session", { "/tcsauc" }, RegisterToSellWithTC)

local function MakeUndermineKazzakLink()
   local item_info = GetAuctionatorItemInfo()
   if not item_info then return end

   if item_info.itemID then
      local link = 'https://undermine.exchange/#eu-kazzak/' .. item_info.itemID
      _G["SR13-Lib"]["SR13-CopyPasta"].copypasta_popup("EU-Kazzak", link)
   end
end
a_env.register_slash("copypasta_auctionator_undermine_kazzak", { "/aucue" }, MakeUndermineKazzakLink)

