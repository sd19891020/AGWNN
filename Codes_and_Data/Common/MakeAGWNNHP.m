function [TS,HP] = MakeAGWNNHP(dataNorm,GW)

	fgw = ones(size(GW));  % ��ʼ��Ȩ��fgw����һ�����⴦��

    %����AGWNN������
    sampleNum=dataNorm.n;
    xNum=dataNorm.xNum;
    hNum=sampleNum;
    limit1 = sqrt(6.0/(xNum+1+hNum+1));
    limit2 = sqrt(6.0/(hNum+1+1+1)); 
    w1 = limit1*(rand(hNum,xNum)*2.0-1.0);  % ��ʼ��Ȩ��w1
    w2 = limit2*(rand(1,hNum)*2.0-1.0);  % ��ʼ��Ȩ��w2
    b1 = limit1*(rand(hNum,1)*2.0-1.0);  % ��ʼ��Ȩ��b1
    b2 = limit2*(rand(hNum,1)*2.0-1.0);  % ��ʼ��Ȩ��b2
    
    HP.fgw=fgw;
    HP.w1=w1;
    HP.w2=w2;
    HP.b1=b1;
    HP.b2=b2;
    HP.GW=GW;
    
    %ѵ����
    TS.IDS = 1:sampleNum;
    TS.XORI = dataNorm.X';
    TS.YORI = dataNorm.Y';
    
end

