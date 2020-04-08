function [grad, orin] = calc_grad(image)
sobelx = [-1 0 1; -2 0 2; -1 0 1];
% -1 0 1
% -2 0 2
% -1 0 1
sobely = [1 2 1; 0 0 0; -1 -2 -1];
% 1 2 1
% 0 0 0
%-1-2-1
x = conv2(image, sobelx, 'same');
y = conv2(image, sobely, 'same');
grad = abs(x) + abs(y);
orin = atan(y / x);
left = x < 0;
orin = orin + left*pi;
right_down = orin < 0;
orin = orin + right_down*pi*2;
end