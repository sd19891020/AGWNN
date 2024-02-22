function [STAT] = XStat(X,Y,YHat)
    [M,N]=size(X);
    STAT.SSE = dot((YHat-Y),(YHat-Y));
    STAT.LOSS = STAT.SSE/2;
    % Residual standard error��׼���в�:�в��ƽ���ͳ���(�в����-1)��ƽ����
    STAT.RSE=sqrt(STAT.SSE/(N-1));
    % ����������
    STAT.MSE = STAT.SSE/N;
    STAT.RMSE = sqrt(STAT.MSE);
    % ���ƽ����SSD���е�ط�ΪSST
    STAT.SSD = dot((Y-mean(Y)),(Y-mean(Y)));%����ƽ����TSS
    STAT.SST = STAT.SSD;
    % �ع�ƽ����SSR��Sum of squares of the regression����Ԥ��������ԭʼ���ݾ�ֵ֮���ƽ����,ESS
    STAT.SSR = dot((YHat-mean(Y)),(YHat-mean(Y))); %sum(bsxfun(@minus, YHat, mean(Y)).^2) 
    % �������ָ�������ָ�����������ж�������ص����г̶ȣ����������Ϊ����ϵ�������ϵ����ƽ�� 
    STAT.R2 = 1-STAT.SSE./STAT.SSD; 
    STAT.R2adj = 1- (((N-1)/(N-M-1))*(1-STAT.R2));
end

