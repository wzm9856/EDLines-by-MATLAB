classdef Points
    properties
        amount = 0;
        edgeNo = zeros(1, 8);
        isEnd;
    end
    methods
        function obj = addEdge(obj, newNo, isEnd)
            obj.amount = obj.amount+1;
            if obj.amount > 8
                
            end
            obj.edgeNo(obj.amount) = newNo;
            obj.isEnd = isEnd;
        end
        function obj = changeEdge(obj, oldNo, newNo)
            loc = obj.edgeNo == oldNo;
            obj.edgeNo(loc) = newNo;
        end
    end
end
        