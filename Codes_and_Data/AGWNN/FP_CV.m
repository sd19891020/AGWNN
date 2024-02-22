function [STAT,YHat,BetaHat,GBetaHat,GGGG] = FP_CV(X,Y,IDS,GW,w1,b1,w2,b2,fgw)
    %X,Yδ��׼����IDs��������ԭʼ���
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
    
%     STAT.SSE = dot((YHat-Y),(YHat-Y));
%     STAT.LOSS = STAT.SSE/2;
%     % Residual standard error��׼���в�:�в��ƽ���ͳ���(�в����-1)��ƽ����
%     STAT.RSE=sqrt(STAT.SSE/(N-1));
%     % ����������
%     STAT.MSE = STAT.SSE/N;
%     STAT.RMSE = sqrt(STAT.MSE);
%     % ���ƽ����SSD���е�ط�ΪSST
%     STAT.SSD = dot((Y-mean(Y)),(Y-mean(Y)));%����ƽ����TSS
%     STAT.SST = STAT.SSD;
%     % �ع�ƽ����SSR��Sum of squares of the regression����Ԥ��������ԭʼ���ݾ�ֵ֮���ƽ����,ESS
%     STAT.SSR = dot((YHat-mean(Y)),(YHat-mean(Y))); %sum(bsxfun(@minus, YHat, mean(Y)).^2) 
%     % �������ָ�������ָ�����������ж�������ص����г̶ȣ����������Ϊ����ϵ�������ϵ����ƽ�� 
%     STAT.R2 = 1-STAT.SSE./STAT.SSD; 
%     STAT.R2adj = 1- (((N-1)/(N-M-1))*(1-STAT.R2));

    [STAT] = XStat(X,Y,YHat);
    [STAT.AICc,STAT.ENP]=AICc(X,Y,YHat,IDS,GW,fgw);
   
end

