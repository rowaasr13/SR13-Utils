local a_name, a_env = ...

function EJLootContainer_RemoveCIMIKnown()
   local scrollBox = EncounterJournal.encounter.info.LootContainer.ScrollBox
   local provider = scrollBox:GetDataProvider()
   local collection = provider:GetCollection()

   -- let's work on table, without bothering to use API and then just re-install same provider back -> this will trigger redraw
   for idx = #collection, 1, -1  do
      local entry = collection[idx]
      local loot_index = entry.index
      if not loot_index then break end -- not an loot item

      local loot_data = C_EncounterJournal.GetLootInfoByIndex(loot_index)
      local slot = loot_data.slot

      local known
      if slot == INVTYPE_NECK then known = true end
      if slot == INVTYPE_FINGER then known = true end
      if slot == INVTYPE_TRINKET then known = true end
      if not known then known = a_env.CIMI_Known(loot_data.link) end

       print(loot_index, loot_data.link, known, loot_data.slot)
      if known then
         table.remove(collection, idx)
      end
   end

   scrollBox:SetDataProvider(provider)
end
