load forDemonstration1

%dataFile = patient6am_afterMed_sit_handopen_left;

skeletonCoords = patient6c_sit_finger_right_skelCoords;
firstFrame = 1;
lastFrame = 400 %size(skeletonCoords,1);
visible = true;


movingMat =zeros (lastFrame, 20);% movingMatrix(dataFile, 'patient6b_sit_finger_left', 0.01);
%movingMat(1:90, joints.FOOTLEFT) = 1;
%movingMat(1:40, joints.FOOTRIGHT) = 1;
%movingMat(end-20:end, joints.HANDLEFT) = 1;
movingMat(:, joints.HANDLEFT) =0;

clipLabels = -1*ones(1, 16);
%clipLabels = labels{10}(1:10);
clipLabels(clipLabels == -1) = 0.05;
numChunks = length(clipLabels);
t = 25/30: 25/30 : ((numChunks)*25)/30;


graphLabels = cell(0);
graphPercentage = cell(0);
croppedT = cell(0);

%initializing first values 
graphPercentage{1}(1) = sign(clipLabels(1) - 0.05);
graphLabels{1} = zeros(1, numChunks);
graphLabels{1}(1) = clipLabels(1);
croppedT{1} = 25/30;

for i = 2:numChunks
    graphLabels{i} = zeros(1, numChunks);
    graphLabels{i}(1:i) = clipLabels(1:i);
    graphPercentage{i} = graphPercentage{i-1};
    graphPercentage{i}(i) = length(find(graphLabels{i} > 0.1))/i;
    croppedT{i} = t(1:i);
end

for i = firstFrame:lastFrame
    fileName = ['image_' num2str(i, '%04d') '.png'];
    img = imread(fileName);
    pieceNum = idivide(i,int32( 25));
    if (i < 25) 
        presentationFrame(img, skeletonCoords(i+1,:), movingMat(i,:), i, visible, zeros(1, numChunks), 0, t, 0 );
    else
        presentationFrame(img, skeletonCoords(i+1,:), movingMat(i,:), i, visible, graphLabels{pieceNum}, graphPercentage{pieceNum}, t, croppedT{pieceNum});
    end
end
