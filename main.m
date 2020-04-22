clearvars; close all; warning off; clc;
SHOW_IMAGE = 0;
image = rgb2gray(imread("150.jpg"));
if SHOW_IMAGE
    imshow(image);title('ORIGINAL IMAGE');
end
disp('1');

gauss = fspecial('gaussian',[5,5],1);
image_gauss = imfilter(image, gauss, 'replicate');
if SHOW_IMAGE
    figure; imshow(image_gauss); title('GAUSSIAN BLUR');
end
disp('2');
%saveas(gcf, 'step222', 'pdf')

[image_grad, image_orin] = calc_grad(image_gauss);
threshold = max(image_grad, [], 'all') * 0.06;
if SHOW_IMAGE
    figure; imshow( abs(image_grad)>threshold ); title('THRESHOLD IMAGE');
end
disp('3');
%saveas(gcf, 'step333', 'pdf');

image_anchor = find_anchor(image_grad, threshold, 3, image_orin, 1);
if SHOW_IMAGE
    figure; imshow(image_anchor);title('ANCHOR POINTS');
end
disp('4');
%saveas(gcf, 'step444', 'pdf')

[image_edge, pointsMat, edgeList, edgeCount] = edge_drawing(image_grad, threshold, image_anchor, image_orin);
if SHOW_IMAGE
    figure; imshow(image_edge); title('EDGE IMAGE');
end
disp('5');
%saveas(gcf, 'step555', 'pdf')

MIN_LENGTH = 16;
[lineList, lineCount] = line_extract(edgeList, edgeCount, pointsMat, MIN_LENGTH);
image_line = false(size(image));
figure; imshow(image_line);title('LINE IMAGE');
for i = 1:lineCount
    lineList(i).drawLine();
end
disp('6');
