function [ann_Net1,Y1,Y2,target,input,gwi,fgwi,LocID] = ForewardPropagation(k,XShuffle_mb,TargetShuffle_mb,IDSShuffle_mb,GW,w1,b1,w2,b2,fgw)
    
    %[N,~]=size(GW);
    target = TargetShuffle_mb(:,k); % 得到一个目标向量
    LocID = IDSShuffle_mb(1,k);
    input = XShuffle_mb(:,k);       % 得到一个输入向量
    gwi=GW(LocID,:);
    fgwi=fgw(LocID,:);
    GWHati=gwi.*fgwi;
    % Step1: 前向计算，第一层
    ann_Xi=[1,input'];
    ann_W1=[b1,w1]';
    ann_Net1=ann_Xi*ann_W1;
    Y1 = GWHati.*ann_Net1;%.*gwi 
     % Step2: 前向计算，第二层
    b2size=size(b2,1);
    if b2size>1
        kb2=b2(LocID);
    else
        kb2=b2;
    end
    ann_In2=[1,Y1];
    ann_W2=[kb2,w2]';
    ann_net2 = ann_In2*ann_W2; %gww2*
    Y2 = ann_net2; % 输出层的激活函数
   
end

