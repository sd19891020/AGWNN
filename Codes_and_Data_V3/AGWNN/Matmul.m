function out = Matmul(x,y)
    [rx,cx] = size(x);
    [ry,cy] = size(y);

    if (cx == cy) & (rx == ry)
        out = x.*y;
    elseif (cx == cy) & (rx == 1)
        out = y.*repmat(x,ry,1);
    elseif (cx == cy) & (ry == 1)
        out = x.*repmat(y,rx,1);
    elseif (rx == ry) & (cx == 1)
        out = y.*repmat(x,1,cy);
    elseif (rx == ry) & (cy == 1)
        out = x.*repmat(y,1,cx);
    else
       error('matmul: non-conformable in row or column dimension')
    end
