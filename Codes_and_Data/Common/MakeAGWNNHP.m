function [TS,HP] = MakeAGWNNHP(dataNorm,GW)

	fgw = ones(size(GW));  % 初始化权重fgw，做一下特殊处理

    %设置AGWNN超参数
    sampleNum=dataNorm.n;
    xNum=dataNorm.xNum;
    hNum=sampleNum;
    limit1 = sqrt(6.0/(xNum+1+hNum+1));
    limit2 = sqrt(6.0/(hNum+1+1+1)); 
    w1 = limit1*(rand(hNum,xNum)*2.0-1.0);  % 初始化权重w1
    w2 = limit2*(rand(1,hNum)*2.0-1.0);  % 初始化权重w2
    b1 = limit1*(rand(hNum,1)*2.0-1.0);  % 初始化权重b1
    b2 = limit2*(rand(hNum,1)*2.0-1.0);  % 初始化权重b2
    
    HP.fgw=fgw;
    HP.w1=w1;
    HP.w2=w2;
    HP.b1=b1;
    HP.b2=b2;
    HP.GW=GW;
    
    %训练集
    TS.IDS = 1:sampleNum;
    TS.XORI = dataNorm.X';
    TS.YORI = dataNorm.Y';
    
end

