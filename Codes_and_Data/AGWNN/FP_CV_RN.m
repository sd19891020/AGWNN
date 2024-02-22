function [STAT,YHat_RRN,BetaHat,GBetaHat,GGGG] = FP_CV_RN(X,Y,IDS,GW,w1,b1,w2,b2,fgw,PS_X,PS_Y)
    %����һ����X,Y���Ѿ���׼����IDs��������ԭʼ���
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
%     % Residual standard error��׼���в�:�в��ƽ���ͳ���(�в����-1)��ƽ����
%     STAT.RSE=sqrt(STAT.SSE/(N-1));
%     % ����������
%     STAT.MSE = STAT.SSE/N;
%     STAT.RMSE = sqrt(STAT.MSE);
%     % ���ƽ����SSD���е�ط�ΪSST
%     STAT.SSD = dot((Y_RRN-mean(Y_RRN)),(Y_RRN-mean(Y_RRN)));%����ƽ����TSS
%     STAT.SST = STAT.SSD;
%     % �ع�ƽ����SSR��Sum of squares of the regression����Ԥ��������ԭʼ���ݾ�ֵ֮���ƽ����,ESS
%     STAT.SSR = dot((YHat-mean(Y_RRN)),(YHat-mean(Y_RRN))); %sum(bsxfun(@minus, YHat, mean(Y)).^2) 
%     % �������ָ�������ָ�����������ж�������ص����г̶ȣ����������Ϊ����ϵ�������ϵ����ƽ�� 
%     STAT.R2 = 1-STAT.SSE./STAT.SSD; 
%     STAT.R2adj = 1- (((N-1)/(N-M-1))*(1-STAT.R2));
    X_RRN=mapminmax('reverse',X,PS_X);
    Y_RRN=mapminmax('reverse',Y,PS_Y);
    YHat_RRN=mapminmax('reverse',YHat,PS_Y);
    [STAT] = XStat(X_RRN,Y_RRN,YHat_RRN);
    
    [STAT.AICc,STAT.ENP]=AICc_RN(X,Y,YHat,IDS,GW,fgw,PS_X,PS_Y);
   
end

