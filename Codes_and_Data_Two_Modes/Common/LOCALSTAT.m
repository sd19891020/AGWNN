function [LSTAT] = LOCALSTAT(M,N,Y,YHat)
    [LSTAT.GSTAT] = STAT(M,N,Y,YHat);
    YMean=mean(Y);
    LSTAT.SSE = (YHat-Y).*(YHat-Y);
    LSTAT.RMSE = sqrt(LSTAT.SSE);
    LSTAT.SSD = (YMean-Y).*(YMean-Y);
    LSTAT.R2 = (LSTAT.SSD-LSTAT.SSE)./LSTAT.SSD;
    LSTAT.R2(find(LSTAT.R2<0.0))=0.001;
end

