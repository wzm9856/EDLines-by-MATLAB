classdef EdgeSeg
    properties
        length = 0;
        pointsList = zeros(2, 80);
    end
    methods
        function obj = addPoint(obj, i, j)
            obj.length = obj.length + 1;
            obj.pointsList(:, obj.length) = [i j];
        end
        function obj = reverseList(obj)
            obj.pointsList(:,1:obj.length) = fliplr(obj.pointsList(1:obj.length));
        end
        function [obj1, obj2] = splitList(obj, i, j)
            obj1 = EdgeSeg(); obj2 = EdgeSeg();
            loca = obj.pointsList == [i;j];
            no = find(all(loca) == 1);
            if isempty(no)
                
            end
            obj1.pointsList(:,1:no) = obj.pointsList(:,1:no);
            try
                obj2.pointsList(:,1:(obj.length-no+1)) = obj.pointsList(:,no:obj.length);
            catch
                a=1;
            end
            obj1.length = no;
            obj2.length = obj.length-no+1;
        end
        function [mat] = printEdge(obj, mat)
            for i = 1:obj.length
                mat(obj.pointsList(1,i),obj.pointsList(2,i))=true;
            end
        end
        function dispEdge(obj)
            disp(obj.pointsList(:,1:obj.length));
        end
    end
end
