function [YHat,YHat_NOR] = PY(X,inModel,Y)

    HP=inModel.HP;
    [N,~] = size(X);
    [NX,~]=mapminmax(X');
    [~,PS_Y]=mapminmax(Y');
    for i=1:N
        NXi = NX(:,i);
        GWi=MakeGWih(HP.UV(i,:),HP.HLUV,HP.bw);
        [HP] = ForewardPropagation(i,NXi,GWi,HP);
        YHat_NOR(:,i)=HP.LYS{HP.LYNum}.Y;
    end
    YHat=mapminmax('reverse',YHat_NOR,PS_Y);
    YHat_NOR=YHat_NOR';
    YHat=YHat';
   
end

