function [output, pointsMat, edgeList, edgeNo] = edge_drawing(grad, thre, anch, orin)
ori = (orin>pi/4 & orin<3*pi/4) | (orin>5*pi/4 & orin<7*pi/4);
pointsMat = repmat(Points, size(grad,1), size(grad,2));
edgeList = repmat(EdgeSeg(size(grad)), 1, 20000);
edgeNo = 0;
output = false(size(grad));
for i = 2:size(grad, 1)-1
    for j = 2:size(grad, 2)-1
        if anch(i, j) == 1 && output(i, j) == 0 % start drawing edge from (i,j)
            edgeNo = edgeNo+1;
            this = [i, j];
            prev = [0, 0];
            edgeList(edgeNo) = edgeList(edgeNo).addPoint(this(1), this(2));
            pointsMat(this(1), this(2)) = pointsMat(this(1), this(2)).addEdge(edgeNo, 1);
            [flag, next] = find_next(this, prev, grad, thre, ori(i,j), output, edgeList(edgeNo));
            while flag == 3 && next(1)>1 && next(1)<size(grad,1) && next(2)>1 && next(2)<size(grad,2)
                % next is adequate, save it in the list and the mat
                prev = this; this = next;
                edgeList(edgeNo) = edgeList(edgeNo).addPoint(this(1), this(2));
                pointsMat(this(1), this(2)) = pointsMat(this(1), this(2)).addEdge(edgeNo, 0);
                output(this(1), this(2)) = 1;
                [flag, next] = find_next(this, prev, grad, thre, ori(i,j), output, edgeList(edgeNo));
            end
            if flag == 0
                pointsMat(this(1), this(2)).isEnd = 1;
            elseif flag == 1
                if pointsMat(next(1), next(2)).isEnd == 0 
                    % if next is in the middle of some edge, we need to split the edge first
                    [seg1, seg2] = edgeList(pointsMat(next(1), next(2)).edgeNo(1)).splitList(next(1), next(2));
                    oldNo = pointsMat(next(1), next(2)).edgeNo(1);
                    edgeNo = edgeNo + 1;
                    for a = 1:seg2.length
                        x = seg2.pointsList(1, a); y = seg2.pointsList(2, a);
                        if x <= 0
                            
                        end
                        pointsMat(x, y).changeEdge(oldNo, edgeNo);
                    end
                pointsMat(next(1), next(2)) = pointsMat(next(1), next(2)).addEdge(edgeNo-1, 1); 
                pointsMat(next(1), next(2)) = pointsMat(next(1), next(2)).addEdge(oldNo, 1); 
                edgeList(oldNo) = seg1;
                edgeList(edgeNo) = seg2;
                elseif pointsMat(next(1), next(2)).isEnd == 1
                    pointsMat(next(1), next(2)) = pointsMat(next(1), next(2)).addEdge(edgeNo, 1);
                end
            end
        end
    end
end
end


function [flag, next] = find_next(this, prev, grad, thre, ori, output, pointList)
% flag: 0--next is out of the edge zone, drawing complete
%       1--next is already drawn, but not in the current edge segment
%       2--next is already drawn and is in the current edge segment
%       3--next is inside the edge zone, drawing continue
i = this(1); j = this(2);
if ori == 0  % orintation of gradient: horizontal
    % vertical edge         A
    %                       B
    %                    ?  ?  ?
    neibour = any(output(i-1:i+1,j-1:j+1), 2);
    de = neibour(1); in = neibour(3);
    if (prev(1)==this(1) || prev(1)==0) && ~in && ~de % edge takes a turn here
        [~, pos] = max([grad(i-1, j-1:j+1), grad(i+1, j-1:j+1)]);
        haha = [[i-1, j-1]; [i-1, j]; [i-1, j+1]; [i+1, j-1]; [i+1, j]; [i+1, j+1]];
        next = haha(pos, :);
    elseif (prev(1)==this(1) || prev(1)==0) && (in || de)
        pos = find([output(i-1, j-1:j+1), output(i+1, j-1:j+1)] == 1, 1);
        haha = [[i-1, j-1]; [i-1, j]; [i-1, j+1]; [i+1, j-1]; [i+1, j]; [i+1, j+1]];
        next = haha(pos, :);
        inCurrent = any(all(pointList.pointsList == next'));
        flag = inCurrent + 1;
        return;
    elseif prev(1)<this(1) && in == 0 % like it in the graph
        [~, pos] = max(grad(i+1, j-1:j+1));
        next = [i+1, j+pos-2];
    elseif prev(1)>this(1) && de == 0 % upside down
        [~, pos] = max(grad(i-1, j-1:j+1));
        next = [i-1, j+pos-2];
    elseif prev(1)<this(1) && in ~=0 % scenario 1 or 2
        pos = find(output(i+1, j-1:j+1) == 1, 1);
        next = [i+1, j+pos-2];
        inCurrent = any(all(pointList.pointsList == next'));
        flag = inCurrent + 1;
        return;
    elseif prev(1)>this(1) && de ~=0
        pos = find(output(i-1, j-1:j+1) == 1, 1);
        next = [i-1, j+pos-2];
        inCurrent = any(all(pointList.pointsList == next'));
        flag = inCurrent + 1;
        return;

    end
else
    % horizontal edge          ?
    %                    A  B  ?
    %                          ?
    neibour = any(output(i-1:i+1,j-1:j+1));
    de = neibour(1); in = neibour(3);
    if (prev(2)==this(2) || prev(2)==0) && ~in && ~de % edge takes a turn here
        [~, pos] = max([grad(i-1:i+1, j-1); grad(i-1:i+1, j+1)]);
        haha = [[i-1, j-1]; [i, j-1]; [i+1, j-1]; [i-1, j+1]; [i, j+1]; [i+1, j+1]];
        next = haha(pos, :);
    elseif (prev(2)==this(2) || prev(2)==0) && (in || de)
        pos = find([output(i-1:i+1, j-1); output(i-1:i+1, j+1)] == 1, 1);
        haha = [[i-1, j-1]; [i, j-1]; [i+1, j-1]; [i-1, j+1]; [i, j+1]; [i+1, j+1]];
        next = haha(pos, :);
        inCurrent = any(all(pointList.pointsList == next'));
        flag = inCurrent + 1;
        return;
    elseif prev(2)<this(2) && in == 0
        [~, pos] = max(grad(i-1:i+1, j+1));
        next = [i+pos-2, j+1];
    elseif prev(2)>this(2) && de == 0
        [~, pos] = max(grad(i-1:i+1, j-1));
        next = [i+pos-2, j-1];
    elseif prev(2)<this(2) && in ~=0 % scenario 1 or 2
        pos = find(output(i-1:i+1, j+1) == 1, 1);
        next = [i+pos-2, j+1];
        inCurrent = any(all(pointList.pointsList == next'));
        flag = inCurrent + 1;
        return;
    elseif prev(2)>this(2) && de ~=0
        pos = find(output(i-1:i+1, j-1) == 1, 1);
        next = [i+pos-2, j-1];
        inCurrent = any(all(pointList.pointsList == next'));
        flag = inCurrent + 1;
        return;

    end
end
if grad(next(1), next(2)) > thre % the point to be connected should in the edge zone
    flag = 3;
else
    flag = 0;
end
end
