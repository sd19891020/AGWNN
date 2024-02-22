function [TS,HP] = MakeAGWNNHP3(targetNum,dataNorm,allGW)

    %计算距离矩阵
    UV=[dataNorm.u,dataNorm.v];
    allDist= pdist2(UV, UV , 'euclidean');

    %设置AGWNN超参数
    sampleNum=dataNorm.n;
    xNum=dataNorm.xNum;
    hNum=targetNum;
    limit1 = sqrt(6.0/(xNum+1+hNum+1));
    limit2 = sqrt(6.0/(hNum+1+1+1)); 
    w1 = limit1*(rand(hNum,xNum)*2.0-1.0);  % 初始化权重w1
    w2 = limit2*(rand(1,hNum)*2.0-1.0);  % 初始化权重w2
    b1 = limit1*(rand(hNum,1)*2.0-1.0);  % 初始化权重b1
    b2 = limit2*(rand(1,1)*2.0-1.0);  % 初始化权重b2

    rand_index = randperm(sampleNum);
    HLIndexs = sort(rand_index(1:targetNum));
    
    GW=allGW(HLIndexs,HLIndexs);
    fgw = ones(size(GW));  % 初始化权重fgw，做一下特殊处理
    
    HP.fgw=fgw;
    HP.w1=w1;
    HP.w2=w2;
    HP.b1=b1;
    HP.b2=b2;
    HP.GW=GW;
    HP.HLIndexs=HLIndexs;
    
    HP.allGW=allGW;
    HP.allDist=allDist;
    
    %训练集
    TS.IDS = 1:targetNum;
    TS.XORI = dataNorm.X(HLIndexs,:)';
    TS.YORI = dataNorm.Y(HLIndexs,:)';
    
    TS.allIDS = 1:sampleNum;
    TS.allXORI = dataNorm.X';
    TS.allYORI = dataNorm.Y';
    
end

