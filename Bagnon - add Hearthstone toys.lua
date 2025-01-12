local size = 32

local item_ids = {
   64488,
   142542,
   162973,
   163045,
   165669,
   165670,
   165802,
   166746,
   180290, -- Night Fae Hearthstone
   182773, -- Necrolord Hearthstone
   188952,
   209035,
   212337,
}
local low_prio_item_ids = { 166747 }

-- Item is guaranteed to be available and thus cached
-- For example "have level 80 on account" is elgible requirement to cache, but "current covenant is XXX" is not, because covenant can be changed
local item_available = {}

local item_requirements = {}
local function CurrentCovenantOrRenown80Achievement(self_id, covenant_id, achievement_id)
   local id, name, points, completed = GetAchievementInfo(achievement_id) -- Renown 80 account achievement, can be cached if completed
   if completed then item_available[self_id] = true return true end

   local covenant_id = C_Covenants.GetActiveCovenantID()
   if covenant_id == covenant_id then return true end
end

item_requirements[182773] = function(self_id) return CurrentCovenantOrRenown80Achievement(self_id, Enum.CovenantType.Necrolord, 15243) end
item_requirements[180290] = function(self_id) return CurrentCovenantOrRenown80Achievement(self_id, Enum.CovenantType.NightFae,  15244) end

local covenant_hearthstone = {
   [Enum.CovenantType.Kyrian] = 184353,
   [Enum.CovenantType.Venthyr] = nil,
}

local in_combat
local has_item_id = {}

local After = C_Timer.After
local InCombatLockdown = InCombatLockdown
local PlayerHasToy = PlayerHasToy
local random = math.random

local dprint = print -- function() end -- print

local function AddKnownToys(found, found_array, check_array)
   for idx = 1, #check_array do
      local item_id = check_array[idx]
      local available = item_available[item_id]

      if not available then repeat
         if not PlayerHasToy(item_id) then break end

         local special_requirements = item_requirements[item_id]
         if special_requirements then
            -- has special requirements, requirements check functions will do the caching if possible
            available = special_requirements(item_id)
         else
            -- no special requirements, item can be cached forever
            item_available[item_id] = true
         end
      until true end

      if available then
         found = found + 1
         found_array[found] = item_id
      end
   end

   return found
end

local function SelectRandomToy()
   local found = 0
   found = AddKnownToys(found, has_item_id, item_ids)
   if found == 0 then found = AddKnownToys(found, has_item_id, low_prio_item_ids) end

   local covenant_id = C_Covenants.GetActiveCovenantID()
   local item_id = covenant_id and covenant_hearthstone[covenant_id]
   if item_id and PlayerHasToy(item_id) then
      found = found + 1
      has_item_id[found] = item_id
   end

   if found > 0 then return has_item_id[random(found)] end
end

local BagnonInventoryFrame
local function FindBagnonInventoryFrame()
   if not Bagnon then return end
   if BagnonInventoryFrame then return end
   if BagnonInventory1 then BagnonInventoryFrame = BagnonInventory1 return end

   local children = { UIParent:GetChildren() }
   for idx = 1, #children do
      local child = children[idx]
      if child.OwnerSelector and child.id == "inventory" then
         BagnonInventoryFrame = child
         return
      end
   end
end

local function OnEvent_CombatAttach(self, event)
   if event == "PLAYER_REGEN_DISABLED" then
      in_combat = true
      self:SetParent(nil)
      self:ClearAllPoints()
      self:Hide()
   elseif
      event == "PLAYER_REGEN_ENABLED" then
      in_combat = false
   else
      in_combat = InCombatLockdown()
   end

   if in_combat then return end

   if not BagnonInventoryFrame then FindBagnonInventoryFrame() end
   local target_frame = BagnonInventoryFrame or ContainerFrameCombinedBags

   local toy_item_id = self.toy_item_id or SelectRandomToy()
   if not (target_frame and toy_item_id) then return end
   self:SetAttribute("toy", toy_item_id)
   self.itemID = toy_item_id
   local _, _, _, _, item_texture = GetItemInfoInstant(toy_item_id)
   self:SetNormalTexture(item_texture)

   self:SetParent(target_frame)
   local offset_x = (self.offset_left or 0) * size * -1
   self:SetPoint("TOPRIGHT", target_frame, "BOTTOMRIGHT", 0 + offset_x, 0)
   self.attached = true
   self:Show()
end

local function OnEnter(self)
   GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
   if ( GameTooltip:SetToyByItemID(self.itemID) ) then
      self.UpdateTooltip = OnEnter
   else
      self.UpdateTooltip = nil;
   end
end

local all_buttons = {
   {},                                          -- random toy
   { toy_item_id = 140192, offset_left = 1 },   -- Dalaran Hearthstone
   { toy_item_id = 110560, offset_left = 2 },   -- Garrison Hearthstone
   { toy_item_id = 205255, offset_left = 3 },   -- Niffen Diggin' Mitts (only in Zaralek)
}

local TOKEN_TRY_ATTACHING = {}
local function button_TryAttaching(self)
   OnEvent_CombatAttach(self, TOKEN_TRY_ATTACHING)
end

local function CreateSingleButton(args)
   local button = CreateFrame("Button", nil, nil, "SecureActionButtonTemplate,SecureHandlerMouseUpDownTemplate")

   button:SetWidth(size)
   button:SetHeight(size)
   button:SetAttribute("type", "toy")
   button:Hide()

   if args and args.toy_item_id then button.toy_item_id = args.toy_item_id end
   if args and args.offset_left then button.offset_left = args.offset_left end

   button:SetScript("OnEvent", OnEvent_CombatAttach)
   button:RegisterEvent("PLAYER_REGEN_DISABLED")
   button:RegisterEvent("PLAYER_REGEN_ENABLED")
   button:RegisterEvent("TOYS_UPDATED")
   button:RegisterEvent("PLAYER_ENTERING_WORLD")
   button:RegisterEvent("LOADING_SCREEN_DISABLED")
   button:RegisterForClicks("AnyUp", "AnyDown")

   button:SetScript("OnEnter", OnEnter)
   button:SetScript("OnLeave", function() GameTooltip:Hide() end)

   button.TryAttaching = button_TryAttaching
   button:TryAttaching()

   return button
end

local function CreateHSButtons()
   for idx = 1, #all_buttons do
      local button_data = all_buttons[idx]
      local frame = CreateSingleButton(button_data)
      button_data.frame = frame
   end

   CreateHSButtons = nil
   CreateSingleButton = nil
end

CreateHSButtons()

local function TryAttachingAll()
   for idx = 1, #all_buttons do
      local button_data = all_buttons[idx]
      local frame = button_data.frame
      if frame and frame.TryAttaching then
         frame:TryAttaching()
      end
   end
end

local function TryAttachingAllOnNextFrame()
   After(0, TryAttachingAll)
end

if Bagnon then
   if Bagnon.Frame  and Bagnon.Frame.New  then hooksecurefunc(Bagnon.Frame,  "New", TryAttachingAllOnNextFrame) end
   if Bagnon.Frames and Bagnon.Frames.New then hooksecurefunc(Bagnon.Frames, "New", TryAttachingAllOnNextFrame) end
end
