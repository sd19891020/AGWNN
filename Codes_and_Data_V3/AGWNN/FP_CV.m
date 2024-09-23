function [STAT,YHat_RRN,YHat,HP,BetaHat] = FP_CV(X,Y,HP,PS_X,PS_Y)
    [~,N]=size(X);
    YHat=zeros(1,N);
    for i=1:N
        GWi=MakeGWih(HP.UV(i,:),HP.HLUV,HP.bw);
        [HP,~,~,~] = ForewardPropagation(i,i,HP.GWRBH',X,Y,GWi,HP);
        YHat(:,i)=HP.LYS{HP.LYNum}.Y;
        
        fGWi=HP.LYS{5}.fgw(i,:);
        ann_W=[HP.LYS{4}.b,HP.LYS{4}.w];
        BB=(HP.LYS{5}.w.*GWi.*fGWi)*ann_W;
        BetaHat(:,i)=(HP.LYS{3}.Y.*BB)';
    end

    X_RRN=mapminmax('reverse',X,PS_X);
    Y_RRN=mapminmax('reverse',Y,PS_Y);
    YHat_RRN=mapminmax('reverse',YHat,PS_Y);
    [STAT] = XStat(X_RRN,Y_RRN,YHat_RRN);
    
    [STAT.AICc,STAT.ENP]=AICc(X_RRN,Y_RRN,YHat_RRN,HP);
   
end

