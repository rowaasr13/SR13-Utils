local a_name, a_env = ...

function a_env.FindFrameByPredicate(predicate)
   local frame = EnumerateFrames()
   while frame do
      if predicate(frame) then return frame end
      frame = EnumerateFrames(frame)
   end
end
