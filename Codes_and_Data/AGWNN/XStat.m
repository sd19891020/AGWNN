function [STAT] = XStat(X,Y,YHat)
    [M,N]=size(X);
    STAT.SSE = dot((YHat-Y),(YHat-Y));
    STAT.LOSS = STAT.SSE/2;
    % Residual standard error标准化残差:残差的平方和除以(残差个数-1)的平方根
    STAT.RSE=sqrt(STAT.SSE/(N-1));
    % 计算均方误差
    STAT.MSE = STAT.SSE/N;
    STAT.RMSE = sqrt(STAT.MSE);
    % 离差平方和SSD，有点地方为SST
    STAT.SSD = dot((Y-mean(Y)),(Y-mean(Y)));%总体平方和TSS
    STAT.SST = STAT.SSD;
    % 回归平方和SSR，Sum of squares of the regression，即预测数据与原始数据均值之差的平方和,ESS
    STAT.SSR = dot((YHat-mean(Y)),(YHat-mean(Y))); %sum(bsxfun(@minus, YHat, mean(Y)).^2) 
    % 计算相关指数，相关指数则是用来判断曲线相关的密切程度，线性情况下为决定系数，相关系数的平方 
    STAT.R2 = 1-STAT.SSE./STAT.SSD; 
    STAT.R2adj = 1- (((N-1)/(N-M-1))*(1-STAT.R2));
end

