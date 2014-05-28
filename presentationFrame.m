function [ output_args ] = presentationFrame( img, skeletonCoord, imgNum, visible, chunkLabels, timePercentage, t, croppedT);
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

head = skeletonCoord(1:2);
shoulderCenter = skeletonCoord(3:4);
leftShoulder = skeletonCoord(5:6);
leftElbow = skeletonCoord(7:8);
leftWrist = skeletonCoord(9:10);
leftHand = skeletonCoord(11:12);
rightShoulder = skeletonCoord(13:14);
rightElbow = skeletonCoord(15:16);
rightWrist = skeletonCoord(17:18);
rightHand = skeletonCoord(19:20);
spine = skeletonCoord(21:22);
hipCenter = skeletonCoord(23:24);
hipLeft = skeletonCoord(25:26);
kneeLeft = skeletonCoord(27:28);
ankleLeft = skeletonCoord(29:30);
footLeft = skeletonCoord(31:32);
hipRight = skeletonCoord(33:34);
kneeRight = skeletonCoord(35:36);
ankleRight = skeletonCoord(37:38);
footRight = skeletonCoord(39:40);

if (visible)
    f= figure();
else
    f = figure('visible','off');
end

set(f, 'Position', [100 100 1200 600]);
set(f, 'PaperSize', [10 6]);
%set(f, 'PaperPosition', [0.05 0.05 0.9 0.9]);
subplot (2,5, [1 2 3 6 7 8])
blurred_img = blurFaceOnImage(img, head);
im = imshow(blurred_img);
axesHandle = gca;
set (axesHandle, 'Position', [0.01 0.01 0.6 1]);
coords = [head;shoulderCenter; leftShoulder;leftElbow; leftWrist; leftHand; ...
    rightShoulder; rightElbow; rightWrist; rightHand; spine; hipCenter;
    hipLeft; kneeLeft; ankleLeft; footLeft; hipRight; kneeRight; ankleRight; footRight];
hold on;
plot (axesHandle,[head(1); shoulderCenter(1)],[head(2); shoulderCenter(2)],'LineWidth', 2);
plot (axesHandle,[leftShoulder(1), shoulderCenter(1)],[leftShoulder(2), shoulderCenter(2)], 'LineWidth', 2);
plot (axesHandle,[rightShoulder(1), shoulderCenter(1)],[rightShoulder(2), shoulderCenter(2)], 'LineWidth', 2);
plot (axesHandle,[leftShoulder(1), leftElbow(1)],[leftShoulder(2), leftElbow(2)], 'LineWidth', 2);
plot (axesHandle,[leftWrist(1), leftElbow(1)],[leftWrist(2), leftElbow(2)],'LineWidth', 2);
plot (axesHandle,[leftWrist(1), leftHand(1)],[leftWrist(2), leftHand(2)], 'LineWidth', 2);
plot (axesHandle,[rightShoulder(1), rightElbow(1)],[rightShoulder(2), rightElbow(2)], 'LineWidth', 2);
plot (axesHandle,[rightWrist(1), rightElbow(1)],[rightWrist(2), rightElbow(2)], 'LineWidth', 2);
plot (axesHandle,[rightWrist(1), rightHand(1)],[rightWrist(2), rightHand(2)], 'LineWidth', 2);
plot (axesHandle,[spine(1), shoulderCenter(1)],[spine(2), shoulderCenter(2)], 'LineWidth', 2);
plot (axesHandle,[spine(1), hipCenter(1)],[spine(2), hipCenter(2)], 'LineWidth', 2);
plot (axesHandle,[hipLeft(1), hipCenter(1)],[hipLeft(2), hipCenter(2)], 'LineWidth', 2);
plot (axesHandle,[hipLeft(1), kneeLeft(1)],[hipLeft(2), kneeLeft(2)], 'LineWidth', 2);
plot (axesHandle,[kneeLeft(1), ankleLeft(1)],[kneeLeft(2), ankleLeft(2)], 'LineWidth', 2);
plot (axesHandle,[footLeft(1), ankleLeft(1)],[footLeft(2), ankleLeft(2)], 'LineWidth', 2);
plot (axesHandle,[hipRight(1), hipCenter(1)],[hipRight(2), hipCenter(2)],  'LineWidth', 2);
plot (axesHandle,[hipRight(1), kneeRight(1)],[hipRight(2), kneeRight(2)],  'LineWidth', 2);
plot (axesHandle,[kneeRight(1), ankleRight(1)],[kneeRight(2), ankleRight(2)],  'LineWidth', 2);
plot (axesHandle,[footRight(1), ankleRight(1)],[footRight(2), ankleRight(2)],  'LineWidth', 2);

plot (axesHandle, coords(:,1), coords(:,2), 'r.', 'MarkerSize', 12);

hold off;

subplot (2,5, [4,5])
set (gca, 'Position', [0.64 0.6 0.34 0.25]);
 

bar (t, chunkLabels);
axis ([0 t(end)+0.5 -0.25 1.25])

subplot(2,5, [9,10])
set (gca, 'Position', [0.64 0.15 0.34 0.25]);
plot (croppedT, timePercentage);
axis ([0 t(end)+0.5 -0.25 1.25])
text(1, 0.3, num2str(timePercentage(end)), 'Fontsize',18);

 imgName = ['presentationFrame_' num2str(imgNum,'%04d')];
 print('-dpng', '-r200', imgName);
 close
end

