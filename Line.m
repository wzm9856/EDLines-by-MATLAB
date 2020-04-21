classdef Line
    properties
        start = [0, 0];
        ending = [0, 0];
        length = 0;
        pointsList = zeros(2,50);
        coef = [0, 0];
        ori = false; % 1 for vertical, 0 for horizontal
    end
    methods
        function obj = addString(obj, pointsList)
            obj.pointsList(:,obj.length+1:obj.length+size(pointsList,2)) = pointsList;
            obj.length = obj.length + size(pointsList,2);
        end
        function obj = addSegment(obj, edgeList, bestseq, start, ending, flip)
            if size(bestseq,2) == 1
                try
                    obj = obj.addString(edgeList(bestseq(1)).pointsList(:,start:ending));
                catch
                    
                end
                return
            end
            obj = obj.addString(edgeList(bestseq(1)).pointsList(:,start:edgeList(bestseq(1)).length));
            a = 2;
            while a < size(bestseq, 2) && bestseq(a+1) ~= 0
                obj = obj.addString(edgeList(bestseq(a)).pointsList(:,2:size(edgeList(bestseq(a)).pointsList,2)));
                a = a+1;
            end
            if find(flip == bestseq(a))
                edgeList(bestseq(a))=edgeList(bestseq(a)).reverseList();
            end
            obj = obj.addString(edgeList(bestseq(a)).pointsList(:,2:ending));
        end
        function obj = calcFinalCoef(obj)
            obj.coef = polyfit(obj.pointsList(1,1:obj.length), obj.pointsList(2,1:obj.length), 1);
            if abs(obj.coef(1))>1
                obj.ori = true;
                obj.coef = polyfit(obj.pointsList(2,1:obj.length), obj.pointsList(1,1:obj.length), 1);
            else
                obj.ori = false;
            end
            obj.start = obj.pointsList(:,1)';
            obj.ending = obj.pointsList(:,obj.length)';
        end
        function drawLine(obj)
            if obj.start(1)==0||obj.ending(1)==0||obj.start(2)==0||obj.ending(2)==0
                
            end
            line([obj.start(2), obj.ending(2)], [obj.start(1), obj.ending(1)], 'color', 'w');
        end
    end
end