function [firstFrame,lastFrame] = clipRange(allBodyData)
    
   firstFrame = min(allBodyData(1).frameNums);
   lastFrame = max(allBodyData(1).frameNums);
    for i = 2:joints.NUM_OF_JOINTS
        firstFrame = min (firstFrame, min(allBodyData(i).frameNums));
        lastFrame = max(lastFrame, max(allBodyData(i).frameNums));
    end
end