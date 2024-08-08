local IsMerchantItemAlreadyKnown = LibStub("LibTTScan-1.0").IsMerchantItemAlreadyKnown
local GetMerchantItemPetSpeciesID = LibStub("LibTTScan-1.0").GetMerchantItemPetSpeciesID
local item_icon_color = CreateColor(0.6, 0.2, 0.2)
local item_name_text_color = CreateColor(0.6, 0.2, 0.2)

local function ColorMerchantButton(button_idx, item_name_text_color, item_icon_color)
   if item_name_text_color then
      local nameText = _G["MerchantItem" .. button_idx .. "Name"]
      local text = nameText:GetText()
      text = item_name_text_color:WrapTextInColorCode(text)
      nameText:SetText(text)
   end

   -- local merchantButton = _G["MerchantItem" .. button_idx]
   -- SetItemButtonSlotVertexColor     (merchantButton, 0.4, 0, 0);

   local itemButton = _G["MerchantItem" .. button_idx .. "ItemButton"]
   SetItemButtonTextureVertexColor      (itemButton, item_icon_color:GetRGB())
   SetItemButtonNormalTextureVertexColor(itemButton, item_icon_color:GetRGB())
end

local function ColorFilterMerchantItems()
   for i=1, MERCHANT_ITEMS_PER_PAGE do
      local index = (((MerchantFrame.page - 1) * MERCHANT_ITEMS_PER_PAGE) + i)
      local known = IsMerchantItemAlreadyKnown(index)
      local species_id, collected, max_collected
      if not known then species_id = GetMerchantItemPetSpeciesID(index) end
      if species_id then collected, max_collected = C_PetJournal.GetNumCollectedInfo(species_id) end

      if collected ~= max_collected then
         local nameText = _G["MerchantItem" .. i .. "Name"]
         local text = nameText:GetText()
         text = ("(%d/%d) %s"):format(collected, max_collected, text)
         nameText:SetText(text)
      end

      local color_item = (known or (collected and collected > 0))

      if color_item then
         ColorMerchantButton(i, item_name_text_color, item_icon_color)
      end

   end
end
hooksecurefunc("MerchantFrame_UpdateMerchantInfo", ColorFilterMerchantItems)
