function [GWih] = MakeGWih(iUV,hUV,bw)
    dist = pdist2(iUV, hUV , 'euclidean');
    GWih = exp(-(dist./bw).^2);
end

