function [HP,target,input,gwrbh] = BH(k,GWRBH_mb,XShuffle_mb,TargetShuffle_mb,GWk,LYS)

    target = TargetShuffle_mb(:,k);
    input = XShuffle_mb(:,k);
    gwrbh = GWRBH_mb(:,k);
    
    %step1
    LYS{1}.Y=gwrbh';
    %step2
    ann_In1=[1,LYS{1}.Y]; 
    ann_W1=[LYS{1}.b,LYS{1}.w]';
    NET2=ann_In1*ann_W1;
    gwrhbh=LYS{2}.AF(NET2);
    %step3
    ann_In2=[1,gwrhbh];
    ann_W2=[LYS{2}.b,LYS{2}.w]';
    NET3=ann_In2*ann_W2;
    snbh=LYS{3}.AF(NET3);
    %step4
    %step5
    ann_In4=snbh;
    ann_W4=[LYS{4}.b,LYS{4}.w]';
    NET5=ann_In4*ann_W4;
    sngwbh=GWk.*NET5;
    %step6
    ann_W=[HP.LYS{4}.b,HP.LYS{4}.w];
        BB=(HP.LYS{5}.w.*GWi.*fGWi)*ann_W;
        BetaHat(:,i)=(HP.LYS{3}.Y.*BB)'

end

