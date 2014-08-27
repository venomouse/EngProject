function [new_img ] = blurFaceOnImage(image, headCoords)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

numPoints = 10;
r = 30;
angles = linspace (0, 2*pi, numPoints);
[x,y] = pol2cart (angles, r*ones(1, numPoints));

x = ceil(x)+headCoords(2);
y = ceil(y)+headCoords(1);

roi_head = roipoly(image, y,x);
h = fspecial ('disk',15);
new_img = uint8(zeros(size(image)));
for i =1:3
    layer = image (:,:,i);
    new_layer = roifilt2(h, layer,roi_head);
    new_img(:,:,i) = new_layer;
end



end

