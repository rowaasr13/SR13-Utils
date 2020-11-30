local arrow_frame

local function FindArrowFrame()
   local frame = EnumerateFrames()

   while frame do
      local region1 = frame:GetRegions()
      if region1 and region1.GetTexture and region1:GetTexture() == "Interface\\AddOns\\WorldQuestsList\\Arrows" then
         arrow_frame = frame
         return
      end
      frame = EnumerateFrames(frame)
   end
end

function WQLAF(divisor)
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
   arrow_frame:SetPoint(point, relativeTo, relativePoint, xOfs, yOfs)
   print("centered!")
end