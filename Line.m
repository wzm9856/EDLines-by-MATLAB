classdef Line
    properties
        start = [0, 0];
        ending = [0, 0];
        length = 0;
        pointsList = zeros(2,200);
        coef = [0, 0];
        ori = false; % 1 for vertical, 0 for horizontal
    end
    methods
        function obj = addInitPoints(obj, initPointsList)
            obj.length = size(initPointsList,2);
            obj.pointsList(:,1:obj.length) = initPointsList;
            obj.start = initPointsList(:,1)';
        end
        function obj = addPoint(obj, loc)
            obj.length = obj.length + 1;
            obj.pointsList(:, obj.length) = loc';
        end
        function obj = calcFinalCoef(obj)
            obj.coef = polyfit(obj.pointsList(1,1:obj.length), obj.pointsList(2,1:obj.length), 1);
            if abs(obj.coef(1))>1
                obj.ori = true;
                obj.coef = polyfit(obj.pointsList(2,1:obj.length), obj.pointsList(1,1:obj.length), 1);
            else
                obj.ori = false;
            end
            obj.ending = obj.pointsList(:,obj.length)';
        end
        function drawLine(obj)
            if obj.ori == 0
                s = obj.start(1)*obj.coef(1)+obj.coef(2);
                e = obj.ending(1)*obj.coef(1)+obj.coef(2);
                line([s, e],[obj.start(1), obj.ending(1)], 'color', 'w');
            else
                if obj.start(2)==455||obj.ending(2)==455
                    
                end
                s = obj.start(2)*obj.coef(1)+obj.coef(2);
                e = obj.ending(2)*obj.coef(1)+obj.coef(2);
                line([obj.start(2), obj.ending(2)], [s, e], 'color', 'w');
            end
        end
    end
end