clearvars; close all; clc;
image = rgb2gray(imread("1.png"));
imshow(image);
disp('1');

gauss = fspecial('gaussian',[5,5],1);
image_gauss = imfilter(image, gauss, 'replicate');
figure; imshow(image_gauss);
disp('2');
saveas(gcf, 'step222', 'pdf')

% image_gauss = image;
[image_grad, image_orin] = calc_grad(image_guass);
% image_ori = abs(image_x) > abs(image_y);
% 1 for vertical edge and 0 for horizontal edge
% threshold = max(image_grad, [], 'all') * 0.05;
% image_thre = abs(image_grad) > threshold;
figure; imshow( abs(image_grad)>threshold);
disp('3');
saveas(gcf, 'step333', 'pdf');

image_anchor = find_anchor(image_grad, image_thre, 1);
figure; imshow(image_anchor);
disp('4');
saveas(gcf, 'step444', 'pdf')

[image_edge, pointsMat, edgeList, edgeCount] = edge_drawing(image_grad, threshold, image_anchor, image_ori);
figure; imshow(image_edge);
disp('5');
saveas(gcf, 'step555', 'pdf')

MIN_LENGTH = 16;
[lineList, lineCount] = line_extract(edgeList, edgeCount, pointsMat, MIN_LENGTH);
image_line = false(size(image));
figure; imshow(image_line);
for i = 1:lineCount
    lineList(i).drawLine();
end
