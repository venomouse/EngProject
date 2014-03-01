function playMovie( frames, frameRate)
%PLAYMOVIE Summary of this function goes here
%   Detailed explanation goes here
[h, w, p] = size(frames(2).cdata);
hf = figure; 
% resize figure based on frame's w x h, and place at (150, 150)
set(hf,'Position', [300 300 w-50 h-50]);
axis off
% Place frames at bottom left
movie(hf,frames,1,frameRate,[0 0 0 0]);

end

