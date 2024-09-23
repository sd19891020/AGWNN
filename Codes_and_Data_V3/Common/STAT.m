function [STAT] = STAT(M,N,Y,YHat)
    STAT.SSE = dot((YHat-Y),(YHat-Y));
    STAT.LOSS = STAT.SSE/2;
    STAT.RSE=sqrt(STAT.SSE/(N-1));
    STAT.MSE = STAT.SSE/N;
    STAT.RMSE = sqrt(STAT.MSE);
    STAT.SSD = dot((Y-mean(Y)),(Y-mean(Y)));
    STAT.SST = STAT.SSD;
    STAT.SSR = dot((YHat-mean(Y)),(YHat-mean(Y)));
    STAT.R2 = 1-STAT.SSE./STAT.SSD; 
    STAT.R2adj = 1- (((N-1)/(N-M-1))*(1-STAT.R2));
    [STAT.PR,STAT.PP] = corr(Y,YHat,'type','Pearson');
end

