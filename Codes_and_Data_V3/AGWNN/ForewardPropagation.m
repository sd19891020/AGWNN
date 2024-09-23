function [HP,target,input,gwrbh] = ForewardPropagation(k,LocID,GWRBH_mb,XShuffle_mb,TargetShuffle_mb,GWk,HP)

    target = TargetShuffle_mb(:,k);
    input = XShuffle_mb(:,k);
    gwrbh = GWRBH_mb(:,k);
    
    %step1
    HP.LYS{1}.Y=gwrbh';
    %step2
    ann_In1=[1,HP.LYS{1}.Y]; 
    ann_W1=[HP.LYS{1}.b,HP.LYS{1}.w]';
    NET2=ann_In1*ann_W1;
    HP.LYS{2}.NET=NET2;
    HP.LYS{2}.Y=HP.LYS{2}.AF(NET2);
    %step3
    ann_In2=[1,HP.LYS{2}.Y];
    ann_W2=[HP.LYS{2}.b,HP.LYS{2}.w]';
    NET3=ann_In2*ann_W2;
    HP.LYS{3}.NET=NET3;
    HP.LYS{3}.Y=HP.LYS{3}.AF(NET3);
    %step4
    ann_Xi=[1,input'];
    HP.LYS{4}.Y=ann_Xi.*HP.LYS{3}.Y;
    %step5
    ann_In4=[HP.LYS{4}.Y];
    ann_W4=[HP.LYS{4}.b,HP.LYS{4}.w]';
    NET5=ann_In4*ann_W4;
    HP.LYS{5}.NET=NET5;
    fGWk=HP.LYS{5}.fgw(LocID,:);
    mGWk=GWk.*fGWk;
    HP.LYS{5}.Y=HP.LYS{5}.AF(NET5,mGWk);
    %step6
    ann_In5=[1,HP.LYS{5}.Y];
    ann_W5=[HP.LYS{5}.b(:,LocID),HP.LYS{5}.w]';
    NET6=ann_In5*ann_W5;
    HP.LYS{6}.NET=NET6;
    HP.LYS{6}.Y=HP.LYS{6}.AF(NET6);

end

