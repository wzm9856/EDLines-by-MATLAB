function [output] = find_anchor(grad, grad_thre, anch_thre, orin, k)

output = zeros(size(grad));
up =        [0 -1 0;0 1 0;0 0 0];
down =      [0 0 0;0 1 0;0 -1 0];
left =      [0 0 0;-1 1 0;0 0 0];
right =     [0 0 0;0 1 -1;0 0 0];
up_left =   [-1 0 0;0 1 0;0 0 0];
down_right =[0 0 0;0 1 0;0 0 -1];
up_right =  [0 0 -1;0 1 0;0 0 0];
down_left = [0 0 0;0 1 0;-1 0 0];

u  = conv2(grad, up,         'same') > anch_thre;
d  = conv2(grad, down,       'same') > anch_thre;
l  = conv2(grad, left,       'same') > anch_thre;
r  = conv2(grad, right,      'same') > anch_thre;
ul = conv2(grad, up_left,    'same') > anch_thre;
dr = conv2(grad, down_right, 'same') > anch_thre;
ur = conv2(grad, up_right,   'same') > anch_thre;
dl = conv2(grad, down_left,  'same') > anch_thre;
% 4 3 2
%   A 1
%
maxima1 = l & r;
maxima2 = ur & dl;
maxima3 = u & d;
maxima4 = ul & dr;
maxima(:,:,1) = maxima1;
maxima(:,:,2) = maxima2;
maxima(:,:,3) = maxima3;
maxima(:,:,4) = maxima4;

% 4 bar3 3  bar2 2
% bar4           bar1
%        A       1
% bar5           bar8
%   bar6    bar7
bar1 = pi/8;    bar2 = 3*pi/8;  bar3 = 5*pi/8;  bar4 = 7*pi/8;
bar5 = 9*pi/8;  bar6 = 11*pi/8; bar7 = 13*pi/8; bar8 = 15*pi/8;
flag(:,:,1)=orin<bar1 | (orin>bar4&orin<bar5) | orin>bar8;
flag(:,:,2)=(orin>bar1&orin<bar2) | (orin>bar5&orin<bar6);
flag(:,:,3)=(orin>bar2&orin<bar3) | (orin>bar6&orin<bar7);
flag(:,:,4)=(orin>bar3&orin<bar4) | (orin>bar7&orin<bar8);
maxima_final = max(maxima&flag,[],3); %all maxima points
thre_points = grad > grad_thre;
edge_points = maxima_final & thre_points; % all maxima points which has a gradient bigger than grad_thre
if k ~= 1
    no = k;
    while no < size(grad, 1)
        output(no, :) = edge_points(no, :);
        no = no + k;
    end
else
    output = edge_points;
end

