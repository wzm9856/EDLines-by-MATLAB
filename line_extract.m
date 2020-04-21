function [lineList, lineCount] = line_extract(edgeList, edgeCount, pointsMat, MIN_LENGTH)
lineList = repmat(Line, 1, 1000);
lineCount = 0; % how many line have we got so far
checked = false(1, edgeCount); % is the specific edge segment has been checked for lines
for a = 1:edgeCount
    if checked(a) == 1
        continue;
    end
    checked(a) = 1;
    edge = edgeList(a);
    no = 1; % the number of points in the edge segment
    while no <= edge.length-MIN_LENGTH+1
        initPoints = edge.pointsList(:,no:no+MIN_LENGTH-1);
        coef = polyfit(initPoints(1,:), initPoints(2,:), 1);
        if abs(coef(1))>1
            ori = 1; % vertical
            coef = polyfit(initPoints(2,:), initPoints(1,:), 1);
            mse = immse(coef(1).*initPoints(2,:)+coef(2), initPoints(1,:));
        else
            ori = 0; % horizontal
            mse = immse(coef(1).*initPoints(1,:)+coef(2), initPoints(2,:));
        end
        if mse < 1.5 % found MIN_LENGTH points that forms a line
            lineCount = lineCount + 1;
            if lineCount == 162
                
            end
            lineList(lineCount) = lineList(lineCount).addString(initPoints);
            no = no + MIN_LENGTH;
            [seq, count, ending, flip] = fitRecur(edgeList, a, pointsMat, no, coef, ori, false(1, edgeCount));
            [~, number] = max(count);
            bestseq = seq(number, :);
            ending = ending(number);
            lineList(lineCount) = lineList(lineCount).addSegment(edgeList, bestseq, no, ending, flip);
            lineList(lineCount) = lineList(lineCount).calcFinalCoef();
            if size(bestseq,2)==1
                no = ending;
            else
                try
                    checked(bestseq)=1;
                catch
                    
                end
                break
            end
        else
            no = no + 1;
        end
    end
end
end

function [seq, count, stop, flip] = fitRecur(edgeList, edgeCount, pointsMat, start, coef, ori, checked)

    [stop, flag] = fitString(edgeList(edgeCount), start, coef, ori);
    seq=edgeCount; count=stop-start; flip=[];
    if flag
        lastPosit = [edgeList(edgeCount).getPos(0,1) edgeList(edgeCount).getPos(0,2)];
        if(pointsMat(lastPosit(1), lastPosit(2)).amount==1)
            return
        end
        checked(edgeCount)=1;
        seq1=[]; count1=[]; flip=[]; stop=[];
        for i = 1:pointsMat(lastPosit(1), lastPosit(2)).amount
            newedgeCount = pointsMat(lastPosit(1), lastPosit(2)).edgeNo(i);
            if checked(newedgeCount)==1
                continue
            end
            checked(newedgeCount)=1;
            if isequal(edgeList(newedgeCount).getPos(0,0), edgeList(edgeCount).getPos(0,0))
                edgeList(newedgeCount) = edgeList(newedgeCount).reverseList();
                flip = [flip newedgeCount];
            end
            [seq2, count2, stop2, flip2] = fitRecur(edgeList, newedgeCount, pointsMat, 1, coef, ori, checked);
            flip = [flip flip2];
            stop = [stop stop2];
            if size(seq1,2) == 0
                seq1 = seq2; count1 = count2;
            elseif size(seq1,2) == size(seq2,2)
                seq1 = [seq1; seq2]; count1 = [count1; count2];
            elseif size(seq1,2) > size(seq2,2)
                seq2 = [seq2 zeros(size(seq2,1), size(seq1,2)-size(seq2,2))]; % make the size equal
                seq1 = [seq1; seq2]; count1 = [count1; count2];
            elseif size(seq1,2) < size(seq2,2)
                seq1 = [seq1 zeros(size(seq1,1), size(seq2,2)-size(seq1,2))];
                seq1 = [seq1; seq2]; count1 = [count1; count2];
            end
        end
        seq = [seq*ones(size(seq1,1),1) seq1];
        count = count+count1;
    end
end

function [stop, flag] = fitString(edge, start, coef, ori)
% flag: 1: the whole edge has been added to the line, continue fitting
%       0: fitting has been stopped in the middle of an edge segment
a = start;
while a<=edge.length
    x = edge.pointsList(1,a); y = edge.pointsList(2,a);
    if ori == 0
        dist = abs(coef(1)*x - y + coef(2)) / sqrt(coef(1)^2 + 1);
    else
        dist = abs(coef(1)*y - x + coef(2)) / sqrt(coef(1)^2 + 1);
    end
    if dist > 1.5
        break;
    end
    a = a+1;
end
if a == edge.length
    flag = 1;
else
    flag = 0;
end
stop = a-1;
end