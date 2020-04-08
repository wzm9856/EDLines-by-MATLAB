classdef EdgeSeg
    properties
        size;
        length = 0;
        pointsList;
    end
    methods
        function obj = EdgeSeg(size)
            obj.pointsList = zeros(2, sum(size)*2);
            obj.size = sum(size)*2;
        end
        function obj = addPoint(obj, i, j)
            obj.length = obj.length + 1;
            obj.pointsList(1, obj.length) = i;
            obj.pointsList(2, obj.length) = j;
        end
        function obj = reverseList(obj)
            list = fliplr(obj.pointsList(1:obj.length));
            obj.pointsList = zeros(2, obj.size);
            obj.pointsList(:,1:obj.length) = list;
        end
        function [obj1, obj2] = splitList(obj, i, j)
            obj1 = EdgeSeg(obj.size/2); obj2 = EdgeSeg(obj.size/2);
            loca = obj.pointsList == [i;j];
            no = find(all(loca) == 1);
            obj1.pointsList(:,1:no) = obj.pointsList(:,1:no);
            obj2.pointsList(:,1:(obj.length-no+1)) = obj.pointsList(:,no:obj.length);
            obj1.length = no;
            obj2.length = obj.length-no+1;
        end
        function [mat] = printEdge(obj, mat)
            for i = 1:obj.length
                mat(obj.pointsList(1,i),obj.pointsList(2,i))=true;
            end
        end
    end
end
