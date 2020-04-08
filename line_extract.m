function [lineList, lineCount] = line_extract(edgeList, edgeCount, pointsMat, MIN_LENGTH)
lineList = repmat(Line, 1, 3000);
lineCount = 0;
for a = 1:edgeCount
    edge = edgeList(a);
    no = 1;
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
        if mse < 1
            lineCount = lineCount + 1;
            lineList(lineCount) = lineList(lineCount).addInitPoints(initPoints);
            no = no + MIN_LENGTH;
            while no <=edge.length
                x = edge.pointsList(1,no); y = edge.pointsList(2,no);
                if x == 117
                    
                end
                if ori == 0
                    dist = abs(coef(1)*x - y + coef(2)) / sqrt(coef(1)^2 + 1);
                else
                    dist = abs(coef(1)*y - x + coef(2)) / sqrt(coef(1)^2 + 1);
                end
                if dist > 1
                    break;
                end
                lineList(lineCount) = lineList(lineCount).addPoint([x, y]);
                no = no + 1;
            end
            lineList(lineCount) = lineList(lineCount).calcFinalCoef();
        else
            no = no + 1;
        end
    end
end
end