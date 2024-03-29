local arrow_frame
local test_frame
local test_texture
local test_texture_id

local print = function() end

local function FindArrowFrame()
   if not test_texture_id then
      test_frame = CreateFrame("Frame")
      test_texture = test_frame:CreateTexture(nil, "OVERLAY")
      test_texture:SetTexture("Interface\\AddOns\\WorldQuestsList\\Arrows")
      test_texture_id = test_texture:GetTexture()
   end

   local frame = EnumerateFrames()

   while frame do
      if frame ~= test_frame then
         local region1 = frame:GetRegions()
         if region1 and region1.GetTexture then
            local texture = region1:GetTexture()
            print(texture)
            if texture == test_texture_id then
               arrow_frame = frame
               return
            end
         end
      end
      frame = EnumerateFrames(frame)
   end
end

local function WQLArrowAFreeze(divisor)
   divisor = divisor or 8
   if not arrow_frame then FindArrowFrame() end
   if not arrow_frame then return end
   print("found!")

   arrow_frame:SetScript("OnDragStart", nil)
   print("frozen!")
   if arrow_frame:GetNumPoints() ~= 1 then return end
   local point, relativeTo, relativePoint, xOfs, yOfs = arrow_frame:GetPoint(1)
   xOfs = 0
   yOfs = -(UIParent:GetHeight() / divisor)
   VWQL.Arrow_PointX = xOfs
   VWQL.Arrow_PointY = yOfs
   arrow_frame:ClearAllPoints()
   arrow_frame:SetPoint("TOP", UIParent, "TOP", xOfs, yOfs)
   print("centered!")
end
WQLArrowAFreeze()

_G.WQLAF = WQLArrowAFreeze
