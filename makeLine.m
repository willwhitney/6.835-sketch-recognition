% function [x, y] = makeLine(x0, y0, x1, y1)
%   Returns a list of integer x and y coordinates 
%   for a line from point (x0,y0) to point (x1,y1)

function [x, y] = makeLine(x0, y0, x1, y1)
    nx = abs(x1 - x0);
    ny = abs(y1 - y0);
    n = max(nx, ny);

    if (x0 == x1)
        x = ones(1,n+1)*x0;
    else    
        dx = (x1 - x0)/n;
        x = round(x0:dx:x1);
    end

    if (y0 == y1)
        y = ones(1,n+1)*y0;
    else    
        dy = (y1 - y0)/n;
        y = round(y0:dy:y1);
    end
end
