clearvars; close all; clc;
image = rgb2gray(imread("1.png"));
imshow(image);
disp('1');

gauss = fspecial('gaussian',[5,5],1);
image_gauss = imfilter(image, gauss, 'replicate');
figure; imshow(image_gauss);
disp('2');
%saveas(gcf, 'step222', 'pdf')

[image_grad, image_orin] = calc_grad(image_gauss);
threshold = max(image_grad, [], 'all') * 0.05;
figure; imshow( abs(image_grad)>threshold );
disp('3');
%saveas(gcf, 'step333', 'pdf');

image_anchor = find_anchor(image_grad, threshold, 0, image_orin, 1);
figure; imshow(image_anchor);
disp('4');
%saveas(gcf, 'step444', 'pdf')

[image_edge, pointsMat, edgeList, edgeCount] = edge_drawing(image_grad, threshold, image_anchor, image_orin);
figure; imshow(image_edge);
disp('5');
%saveas(gcf, 'step555', 'pdf')

MIN_LENGTH = 16;
[lineList, lineCount] = line_extract(edgeList, edgeCount, pointsMat, MIN_LENGTH);
image_line = false(size(image));
figure; imshow(image_line);
for i = 1:lineCount
    lineList(i).drawLine();
end
