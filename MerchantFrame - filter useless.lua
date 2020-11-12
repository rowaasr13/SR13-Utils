local function ColorFilterMerchantItems()
   for i=1, MERCHANT_ITEMS_PER_PAGE do
      local index = (((MerchantFrame.page - 1) * MERCHANT_ITEMS_PER_PAGE) + i)
      if LibStub("LibTTScan-1.0").IsMerchantItemAlreadyKnown(index) then
         local merchantButton = _G["MerchantItem" .. i]
         SetItemButtonSlotVertexColor     (merchantButton, 0.4, 0, 0);

         -- local nameFrame = _G["MerchantItem" .. i .. "NameFrame"]
         -- SetItemButtonNameFrameVertexColor(merchantButton, 0.8, 0, 0);

         local itemButton = _G["MerchantItem" .. i .. "ItemButton"]
         SetItemButtonTextureVertexColor      (itemButton, 0.4, 0, 0);
         SetItemButtonNormalTextureVertexColor(itemButton, 0.4, 0, 0);
      end
   end
end
hooksecurefunc("MerchantFrame_UpdateMerchantInfo", ColorFilterMerchantItems)
