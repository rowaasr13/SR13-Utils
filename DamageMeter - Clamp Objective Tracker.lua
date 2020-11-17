local points = {}
local _SetPoint = ObjectiveTrackerFrame.SetPoint

function ClampObjectiveTrackerFrameAt(target)
   if not (target and target:IsVisible() and ObjectiveTrackerFrame and ObjectiveTrackerFrame:IsVisible()) then
      return
   end
   local frame = ObjectiveTrackerFrame
   local count = 0
   for idx = 1, frame:GetNumPoints() do
      local point, relativeTo, relativePoint, xOfs, yOfs = frame:GetPoint(idx)
      if not point:find("BOTTOM") then
         count = count + 1
         if not points[count] then points[count] = {} end
         points[count][1] = point
         points[count][2] = relativeTo
         points[count][3] = relativePoint
         points[count][4] = xOfs
         points[count][5] = yOfs
      end
   end
   frame:ClearAllPoints()
   for idx = 1, count do
      _SetPoint(frame, points[idx][1], points[idx][2], points[idx][3], points[idx][4], points[idx][5])
   end

   _SetPoint(frame, "BOTTOM", target, "TOP", 0, 10)
   frame:SetScale(0.95)
end

hooksecurefunc(ObjectiveTrackerFrame, "SetPoint", function()
   ClampObjectiveTrackerFrameAt(Recount_MainWindow)
   ClampObjectiveTrackerFrameAt(SkadaBarWindowSkada)
end)
