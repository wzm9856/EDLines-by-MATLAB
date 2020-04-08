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
maxima = [maxima1; maxima2; maxima3; maxima4];
edge_point = maxima & grad_thre;
if k ~= 1
    no = k;
    while no < size(grad, 1)
        output(no, :) = edge_point(no, :);
        no = no + k;
    end
else
    output = edge_point;
end

