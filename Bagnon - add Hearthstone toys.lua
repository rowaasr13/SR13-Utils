local item_ids = { 64488, 142542, 162973, 163045, 165669, 165670, 180290, 184353 }

local in_combat
local attached
local has_item_id = {}

local After = C_Timer.After
local PlayerHasToy = PlayerHasToy
local random = math.random

local dprint = print -- function() end -- print

local function SelectRandomToy()
   local found = 0
   for idx = 1, #item_ids do
      local item_id = item_ids[idx]
      if PlayerHasToy(item_id) then
         found = found + 1
         has_item_id[found] = item_id
      end
   end
   if found > 0 then return has_item_id[random(found)] end
end

local function OnEvent_CombatAttach(self, event)
   if event == "PLAYER_REGEN_DISABLED" then
      in_combat = true
      self:SetParent(nil)
      self:ClearAllPoints()
      self:Hide()
   end

   if event == "PLAYER_REGEN_ENABLED" then
      in_combat = false
   end

   if in_combat then return end

   local target_frame = BagnonInventoryFrame1
   local toy_item_id = SelectRandomToy()
   if not (target_frame and toy_item_id) then return end

   self:SetAttribute("toy", toy_item_id)
   local _, _, _, _, item_texture = GetItemInfoInstant(toy_item_id)
   self:SetNormalTexture(item_texture)
   self:SetParent(target_frame)
   self:SetPoint("TOPRIGHT", target_frame, "BOTTOMRIGHT", 0, 0)
   attached = true
   self:Show()
end

local ShowHSButton

local function CreateHSButton()
   local size = 32

   local button = CreateFrame("Button", nil, nil, "SecureActionButtonTemplate,SecureHandlerMouseUpDownTemplate")

   button:SetWidth(size)
   button:SetHeight(size)
   button:SetAttribute("type", "toy")
   button:Hide()

   button:SetScript("OnEvent", OnEvent_CombatAttach)
   button:RegisterEvent("PLAYER_REGEN_DISABLED")
   button:RegisterEvent("PLAYER_REGEN_ENABLED")
   button:RegisterEvent("TOYS_UPDATED")
   button:RegisterEvent("PLAYER_ENTERING_WORLD")

   ShowHSButton = function()
      OnEvent_CombatAttach(button, "PLAYER_REGEN_ENABLED")
   end
   ShowHSButton()

   CreateHSButton = nil
end

CreateHSButton()

-- Need better way to detect creation of target_frame
local function TryAttaching()
   ShowHSButton()
   if not attached then
      After(5, TryAttaching)
   end
end
TryAttaching()
