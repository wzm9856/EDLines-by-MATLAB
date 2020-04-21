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
            obj.pointsList(:,1:obj.length) = fliplr(obj.pointsList(:,1:obj.length));
        end
        function [obj1, obj2] = splitList(obj, i, j)
            obj1 = EdgeSeg(); obj2 = EdgeSeg();
            loca = obj.pointsList == [i;j];
            no = find(all(loca) == 1);
            obj1.pointsList(:,1:no) = obj.pointsList(:,1:no);
            obj2.pointsList(:,1:(obj.length-no+1)) = obj.pointsList(:,no:obj.length);
            obj1.length = no;
            obj2.length = obj.length-no+1;
        end
        function mat = draw(obj, mat)
            for i = 1:obj.length
                mat(obj.pointsList(1,i),obj.pointsList(2,i))=true;
            end
        end
        function disp(obj)
            disp(obj.pointsList(:,1:obj.length));
        end
        function out = getPos(obj, no, dim)
            %for no=0, you get the last point in edge
            if no>obj.length
                error('out of index');
            end
            if no == 0
                out = obj.pointsList(:,obj.length);
            else
                out = obj.pointsList(:,no);
            end
            if dim == 0
                return
            end
            out = out(dim);
        end
        function obj1 = connEdge(obj1, obj2)
            L1 = obj1.pointsList(:,1:obj1.length);
            L2 = obj2.pointsList(:,1:obj2.length);
            if isequal(L1(:,obj1.length), L2(:,1))
                % a great scenario, go to end directly
            elseif isequal(L1(:,obj1.length), L2(:,obj2.length))
                obj2 = obj2.reverseList();
            elseif isequal(L1(:,1), L2(:,1))
                obj1 = obj1.reverseList();
            elseif isequal(L1(:,obj1.length), L2(:,1))
                obj1 = obj1.reverseList();
                obj2 = obj2.reverseList();
            else
                error('Try to connect 2 edge segment that are not connected');
            end
            obj1.pointsList(:,obj1.length+1:obj1.length+obj2.length) = obj2.pointsList(:,2:obj2.length);
            obj1.length = obj1.length + obj2.length - 1;
        end
    end
end
