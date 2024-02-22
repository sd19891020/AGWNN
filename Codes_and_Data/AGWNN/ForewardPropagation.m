function [ann_Net1,Y1,Y2,target,input,gwi,fgwi,LocID] = ForewardPropagation(k,XShuffle_mb,TargetShuffle_mb,IDSShuffle_mb,GW,w1,b1,w2,b2,fgw)
    
    %[N,~]=size(GW);
    target = TargetShuffle_mb(:,k); % �õ�һ��Ŀ������
    LocID = IDSShuffle_mb(1,k);
    input = XShuffle_mb(:,k);       % �õ�һ����������
    gwi=GW(LocID,:);
    fgwi=fgw(LocID,:);
    GWHati=gwi.*fgwi;
    % Step1: ǰ����㣬��һ��
    ann_Xi=[1,input'];
    ann_W1=[b1,w1]';
    ann_Net1=ann_Xi*ann_W1;
    Y1 = GWHati.*ann_Net1;%.*gwi 
     % Step2: ǰ����㣬�ڶ���
    b2size=size(b2,1);
    if b2size>1
        kb2=b2(LocID);
    else
        kb2=b2;
    end
    ann_In2=[1,Y1];
    ann_W2=[kb2,w2]';
    ann_net2 = ann_In2*ann_W2; %gww2*
    Y2 = ann_net2; % �����ļ����
   
end

