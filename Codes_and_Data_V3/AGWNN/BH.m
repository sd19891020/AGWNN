function [BetaHat] = BH(GNIndexs,HP_ALL,N,inModel)

    for i=1:N
        GWi=MakeGWih(HP_ALL.UV(i,:),HP_ALL.HLUV,HP_ALL.bw);
        GWi=GWi(:,GNIndexs);
        
        %step1
        gwrbh =HP_ALL.GWRBH(i,:);
        %step2
        ann_In1=[1,gwrbh]; 
        ann_W1=[inModel.LYS{1}.b,inModel.LYS{1}.w]';
        NET2=ann_In1*ann_W1;
        gwrhbh=inModel.LYS{2}.AF(NET2);
        %step3
        ann_In2=[1,gwrhbh];
        ann_W2=[inModel.LYS{2}.b,inModel.LYS{2}.w]';
        NET3=ann_In2*ann_W2;
        snbh=inModel.LYS{3}.AF(NET3);
        %step4-6
        ann_W=[inModel.LYS{4}.b,inModel.LYS{4}.w];
        BB=(inModel.LYS{5}.w.*GWi)*ann_W;
        BetaHat(:,i)=(snbh.*BB)';
    end

end

