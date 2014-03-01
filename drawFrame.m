function [frame ] = drawFrame(skeletonCoord, axesHandle, axisLim, frameNum,unreliableJoints,sticky)
%Input - 60X1 coordinate vector

head = skeletonCoord(indexConstants.HEAD);
shoulderCenter = skeletonCoord(indexConstants.SHOULDERCENTER);
leftShoulder = skeletonCoord(indexConstants.SHOULDERLEFT);
leftElbow = skeletonCoord(indexConstants.ELBOWLEFT);
leftWrist = skeletonCoord(indexConstants.WRISTLEFT);
leftHand = skeletonCoord(indexConstants.HANDLEFT);
rightShoulder = skeletonCoord(indexConstants.SHOULDERIGHT);
rightElbow = skeletonCoord(indexConstants.ELBOWRIGHT);
rightWrist = skeletonCoord(indexConstants.WRISTRIGHT);
rightHand = skeletonCoord(indexConstants.HANDRIGHT);
spine = skeletonCoord(indexConstants.SPINE);
hipCenter = skeletonCoord(indexConstants.HIPCENTER);
hipLeft = skeletonCoord(indexConstants.HIPLEFT);
kneeLeft = skeletonCoord(indexConstants.KNEELEFT);
ankleLeft = skeletonCoord(indexConstants.ANKLELEFT);
footLeft = skeletonCoord(indexConstants.FOOTLEFT);
hipRight = skeletonCoord(indexConstants.HIPRIGHT);
kneeRight = skeletonCoord(indexConstants.KNEERIGHT);
ankleRight = skeletonCoord(indexConstants.ANKLERIGHT);
footRight = skeletonCoord(indexConstants.FOOTRIGHT);


coords = [head;shoulderCenter; leftShoulder;leftElbow; leftWrist; leftHand; ...
    rightShoulder; rightElbow; rightWrist; rightHand; spine; hipCenter;
    hipLeft; kneeLeft; ankleLeft; footLeft; hipRight; kneeRight; ankleRight; footRight];
hold on;
plot3 (axesHandle,[head(1); shoulderCenter(1)],[head(2); shoulderCenter(2)], [head(3); shoulderCenter(3)], 'LineWidth', 3);
plot3 (axesHandle,[leftShoulder(1), shoulderCenter(1)],[leftShoulder(2), shoulderCenter(2)], [leftShoulder(3), shoulderCenter(3)], 'LineWidth', 3);
plot3 (axesHandle,[rightShoulder(1), shoulderCenter(1)],[rightShoulder(2), shoulderCenter(2)], [rightShoulder(3), shoulderCenter(3)], 'LineWidth', 3);
plot3 (axesHandle,[leftShoulder(1), leftElbow(1)],[leftShoulder(2), leftElbow(2)], [leftShoulder(3), leftElbow(3)], 'LineWidth', 3);
plot3 (axesHandle,[leftWrist(1), leftElbow(1)],[leftWrist(2), leftElbow(2)], [leftWrist(3), leftElbow(3)], 'LineWidth', 3);
plot3 (axesHandle,[leftWrist(1), leftHand(1)],[leftWrist(2), leftHand(2)], [leftWrist(3), leftHand(3)], 'LineWidth', 3);
plot3 (axesHandle,[rightShoulder(1), rightElbow(1)],[rightShoulder(2), rightElbow(2)], [rightShoulder(3), rightElbow(3)], 'LineWidth', 3);
plot3 (axesHandle,[rightWrist(1), rightElbow(1)],[rightWrist(2), rightElbow(2)], [rightWrist(3), rightElbow(3)], 'LineWidth', 3);
plot3 (axesHandle,[rightWrist(1), rightHand(1)],[rightWrist(2), rightHand(2)], [rightWrist(3), rightHand(3)], 'LineWidth', 3);
plot3 (axesHandle,[spine(1), shoulderCenter(1)],[spine(2), shoulderCenter(2)], [spine(3), shoulderCenter(3)], 'LineWidth', 3);
plot3 (axesHandle,[spine(1), hipCenter(1)],[spine(2), hipCenter(2)], [spine(3), hipCenter(3)], 'LineWidth', 3);
plot3 (axesHandle,[hipLeft(1), hipCenter(1)],[hipLeft(2), hipCenter(2)], [hipLeft(3), hipCenter(3)], 'LineWidth', 3);
plot3 (axesHandle,[hipLeft(1), kneeLeft(1)],[hipLeft(2), kneeLeft(2)], [hipLeft(3), kneeLeft(3)], 'LineWidth', 3);
plot3 (axesHandle,[kneeLeft(1), ankleLeft(1)],[kneeLeft(2), ankleLeft(2)], [kneeLeft(3), ankleLeft(3)],'LineWidth', 3);
plot3 (axesHandle,[footLeft(1), ankleLeft(1)],[footLeft(2), ankleLeft(2)], [footLeft(3), ankleLeft(3)],'LineWidth', 3);
plot3 (axesHandle,[hipRight(1), hipCenter(1)],[hipRight(2), hipCenter(2)], [hipRight(3), hipCenter(3)], 'LineWidth', 3);
plot3 (axesHandle,[hipRight(1), kneeRight(1)],[hipRight(2), kneeRight(2)], [hipRight(3), kneeRight(3)], 'LineWidth', 3);
plot3 (axesHandle,[kneeRight(1), ankleRight(1)],[kneeRight(2), ankleRight(2)], [kneeRight(3), ankleRight(3)], 'LineWidth', 3);
plot3 (axesHandle,[footRight(1), ankleRight(1)],[footRight(2), ankleRight(2)], [footRight(3), ankleRight(3)], 'LineWidth', 3);

plot3 (coords(:,1), coords(:,2), coords(:,3), 'r.', 'MarkerSize', 14);
if (~isempty(unreliableJoints))
    plot3 (coords(unreliableJoints,1), coords(unreliableJoints,2), coords(unreliableJoints,3), 'ks', 'MarkerSize', 10, 'MarkerFaceColor', 'k');
end

axis(axisLim);
legend (num2str(frameNum));
%hold off;

frame = getframe;
if (~sticky)
    cla reset;
end

end

