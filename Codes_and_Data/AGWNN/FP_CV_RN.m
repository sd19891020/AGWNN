function [STAT,YHat_RRN,BetaHat,GBetaHat,GGGG] = FP_CV_RN(X,Y,IDS,GW,w1,b1,w2,b2,fgw,PS_X,PS_Y)
    %反归一化，X,Y均已经标准化，IDs是样本点原始序号
    [M,N]=size(X);
    YHat=zeros(1,N);
    %Beta=zeros(N,M+1);
    GGGG=[b1,w1];
    rw2=repmat(w2',1,M+1);
    GBetaHat=rw2.*GGGG;
    for i=1:N
        [~,~,YHat(i),~,~,gwi,fgwi,~] = ForewardPropagation(i,X,Y,IDS,GW,w1,b1,w2,b2,fgw);
        GWHati=gwi.*fgwi;
        BetaHat(i,:)=(w2.*GWHati)*GGGG; 
    end
    
%     X_RRN=mapminmax('reverse',X,PS_X);
%     Y_RRN=mapminmax('reverse',Y,PS_Y);
%     YHat_RRN=mapminmax('reverse',YHat,PS_Y);
%     
%     STAT.SSE = dot((YHat_RRN-Y_RRN),(YHat_RRN-Y_RRN));
%     STAT.LOSS = STAT.SSE/2;
%     % Residual standard error标准化残差:残差的平方和除以(残差个数-1)的平方根
%     STAT.RSE=sqrt(STAT.SSE/(N-1));
%     % 计算均方误差
%     STAT.MSE = STAT.SSE/N;
%     STAT.RMSE = sqrt(STAT.MSE);
%     % 离差平方和SSD，有点地方为SST
%     STAT.SSD = dot((Y_RRN-mean(Y_RRN)),(Y_RRN-mean(Y_RRN)));%总体平方和TSS
%     STAT.SST = STAT.SSD;
%     % 回归平方和SSR，Sum of squares of the regression，即预测数据与原始数据均值之差的平方和,ESS
%     STAT.SSR = dot((YHat-mean(Y_RRN)),(YHat-mean(Y_RRN))); %sum(bsxfun(@minus, YHat, mean(Y)).^2) 
%     % 计算相关指数，相关指数则是用来判断曲线相关的密切程度，线性情况下为决定系数，相关系数的平方 
%     STAT.R2 = 1-STAT.SSE./STAT.SSD; 
%     STAT.R2adj = 1- (((N-1)/(N-M-1))*(1-STAT.R2));
    X_RRN=mapminmax('reverse',X,PS_X);
    Y_RRN=mapminmax('reverse',Y,PS_Y);
    YHat_RRN=mapminmax('reverse',YHat,PS_Y);
    [STAT] = XStat(X_RRN,Y_RRN,YHat_RRN);
    
    [STAT.AICc,STAT.ENP]=AICc_RN(X,Y,YHat,IDS,GW,fgw,PS_X,PS_Y);
   
end

