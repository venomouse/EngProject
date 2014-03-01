function [frames] =  makeMovie (data, reliabilityMatrix, sticky, firstFrame, lastFrame)
if (nargin <2)
    reliabilityMatrix = zeros(size(data));
   
end

if (nargin < 3)
    sticky = false;
end

if (nargin< 4)
    firstFrame = 1;
    
end

if (nargin <5)
    lastFrame = size(data,1);
end

threshold = 0.01;

numFrames = lastFrame - firstFrame;

xCoords = data (:, 1:3:end-2);
yCoords = data (:, 2:3:end-1);
zCoords = data (:, 3:3:end);

lim = [min(min(xCoords))-0.1, max(max(xCoords))+0.1, min(min(yCoords))-0.1, max(max(yCoords))+0.1, min(min(zCoords))-0.01, max(max(zCoords))+0.01];


frames(numFrames) = struct('cdata', [], 'colormap', []);
k=2;
f = figure(1);
set(f,'OuterPosition', [ 395    41   576   728]);
set (gca, 'Position', [0.1300  0.1100  0.7750  0.8150]);
set (gca, 'CameraUpVector', [0 1 0]);
 frames(1) = drawFrame(data(firstFrame,:), gca, lim, firstFrame,[], true);
for i = firstFrame+1: lastFrame
    point = data(i,:);
    unreliableJoints = find(reliabilityMatrix (i,:) ==1);
    %norm(data(i, indexConstants.ANKLELEFT) - data(i-1, indexConstants.ANKLELEFT),2) 
    if (norm(data(i, indexConstants.ANKLELEFT) - data(i-1, indexConstants.ANKLELEFT),2) > threshold)
        frames(k) = drawFrame(point, gca, lim, i, unreliableJoints,sticky );
    else
        frames(k) = drawFrame(point, gca, lim, i, unreliableJoints,sticky);
    end
    k = k+1;
end

close 1;
end