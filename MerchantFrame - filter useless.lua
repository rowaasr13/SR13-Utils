local IsMerchantItemAlreadyKnown = LibStub("LibTTScan-1.0").IsMerchantItemAlreadyKnown
local item_icon_color = CreateColor(0.6, 0.2, 0.2)
local item_name_text_color = CreateColor(0.6, 0.2, 0.2)

local function ColorFilterMerchantItems()
   for i=1, MERCHANT_ITEMS_PER_PAGE do
      local index = (((MerchantFrame.page - 1) * MERCHANT_ITEMS_PER_PAGE) + i)
      if IsMerchantItemAlreadyKnown(index) then
         local merchantButton = _G["MerchantItem" .. i]
         -- SetItemButtonSlotVertexColor     (merchantButton, 0.4, 0, 0);

         local nameText = _G["MerchantItem" .. i .. "Name"]
	 nameText:SetText(item_name_text_color:WrapTextInColorCode(nameText:GetText()))

         local itemButton = _G["MerchantItem" .. i .. "ItemButton"]
         SetItemButtonTextureVertexColor      (itemButton, item_icon_color:GetRGB())
         SetItemButtonNormalTextureVertexColor(itemButton, item_icon_color:GetRGB())
      end
   end
end
hooksecurefunc("MerchantFrame_UpdateMerchantInfo", ColorFilterMerchantItems)
